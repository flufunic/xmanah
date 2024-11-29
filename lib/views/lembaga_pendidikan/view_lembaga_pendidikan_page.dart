import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_lembaga_pendidikan_page.dart';
import 'tambah_lembaga_pendidikan_page.dart'; // Import the Tambah Page

class ViewLembagaPendidikanPage extends StatefulWidget {
  @override
  _ViewLembagaPendidikanPageState createState() =>
      _ViewLembagaPendidikanPageState();
}

class _ViewLembagaPendidikanPageState extends State<ViewLembagaPendidikanPage> {
  late Future<List<QueryDocumentSnapshot>> _lembagaDataFuture;

  @override
  void initState() {
    super.initState();
    _lembagaDataFuture = _fetchLembagaData();
  }

  Future<List<QueryDocumentSnapshot>> _fetchLembagaData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('lembaga_pendidikan')
          .get();
      return snapshot.docs;
    } catch (e) {
      print("Gagal mengambil data lembaga pendidikan: $e");
      return [];
    }
  }

  Future<void> _deleteLembaga(String lembagaId) async {
    try {
      await FirebaseFirestore.instance
          .collection('lembaga_pendidikan')
          .doc(lembagaId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data lembaga pendidikan berhasil dihapus'),
      ));
      setState(() {
        _lembagaDataFuture =
            _fetchLembagaData(); // Refresh data setelah dihapus
      });
    } catch (e) {
      print("Gagal menghapus data lembaga pendidikan: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan saat menghapus data'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lembaga Pendidikan'),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _lembagaDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Tidak ada data lembaga pendidikan ditemukan'));
          }

          List<QueryDocumentSnapshot> lembagaData = snapshot.data!;
          return ListView.builder(
            itemCount: lembagaData.length,
            itemBuilder: (context, index) {
              var lembaga = lembagaData[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.school, size: 40),
                  title: Text(lembaga['nama'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alamat: ${lembaga['alamat']}'),
                      Text('Akreditasi: ${lembaga['akreditasi']}'),
                      Text('Tingkat: ${lembaga['tingkat']}'),
                      Text('Kontak: ${lembaga['kontak']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditLembagaPendidikanPage(
                                  lembagaId: lembagaData[index].id),
                            ),
                          );
                          setState(() {
                            _lembagaDataFuture = _fetchLembagaData();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Konfirmasi Hapus'),
                                content: Text(
                                    'Apakah Anda yakin ingin menghapus lembaga ini?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text('Ya'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (confirm == true) {
                            await _deleteLembaga(lembagaData[index].id);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to TambahLembagaPendidikanPage
          bool? added = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahLembagaPendidikanPage(),
            ),
          );
          // If data was added, refresh the list
          if (added == true) {
            setState(() {
              _lembagaDataFuture = _fetchLembagaData();
            });
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Lembaga Pendidikan',
      ),
    );
  }
}
