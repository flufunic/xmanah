import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_fasilitas_kesehatan_page.dart'; // Halaman Edit

class ViewFasilitasKesehatanPage extends StatefulWidget {
  @override
  _ViewFasilitasKesehatanPageState createState() =>
      _ViewFasilitasKesehatanPageState();
}

class _ViewFasilitasKesehatanPageState
    extends State<ViewFasilitasKesehatanPage> {
  late Future<List<QueryDocumentSnapshot>> _fasilitasDataFuture;

  @override
  void initState() {
    super.initState();
    _fasilitasDataFuture = _fetchFasilitasData();
  }

  // Fungsi untuk mengambil data fasilitas kesehatan dari Firestore
  Future<List<QueryDocumentSnapshot>> _fetchFasilitasData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('fasilitas_kesehatan')
          .get();
      return snapshot.docs;
    } catch (e) {
      print("Gagal mengambil data fasilitas kesehatan: $e");
      return [];
    }
  }

  // Fungsi untuk menghapus data fasilitas kesehatan
  Future<void> _deleteFasilitas(String fasilitasId) async {
    try {
      await FirebaseFirestore.instance
          .collection('fasilitas_kesehatan')
          .doc(fasilitasId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data fasilitas kesehatan berhasil dihapus'),
      ));
      setState(() {
        _fasilitasDataFuture =
            _fetchFasilitasData(); // Refresh data setelah dihapus
      });
    } catch (e) {
      print("Gagal menghapus data fasilitas kesehatan: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan saat menghapus data'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fasilitas Kesehatan'),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _fasilitasDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Tidak ada data fasilitas kesehatan ditemukan'));
          }

          List<QueryDocumentSnapshot> fasilitasData = snapshot.data!;
          return ListView.builder(
            itemCount: fasilitasData.length,
            itemBuilder: (context, index) {
              var fasilitas =
                  fasilitasData[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.local_hospital,
                      size: 40), // Changed icon to hospital
                  title: Text(fasilitas['nama'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alamat: ${fasilitas['alamat']}'),
                      Text('Jenis: ${fasilitas['jenis']}'),
                      Text('Kontak: ${fasilitas['kontak']}'),
                      Text('Ulasan: ${fasilitas['ulasan']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          // Arahkan ke halaman edit fasilitas kesehatan
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditFasilitasKesehatanPage(
                                fasilitasId: fasilitasData[index].id,
                                initialData: fasilitas,
                              ),
                            ),
                          );
                          setState(() {
                            _fasilitasDataFuture = _fetchFasilitasData();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          // Konfirmasi sebelum menghapus
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Konfirmasi Hapus'),
                                content: Text(
                                    'Apakah Anda yakin ingin menghapus fasilitas ini?'),
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
                            await _deleteFasilitas(fasilitasData[index].id);
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
    );
  }
}
