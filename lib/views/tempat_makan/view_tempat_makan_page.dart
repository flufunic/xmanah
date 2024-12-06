import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_tempat_makan_page.dart'; // Halaman Edit
import 'tambah_tempat_makan_page.dart'; // Halaman untuk menambah tempat makan

class ViewTempatMakanPage extends StatefulWidget {
  @override
  _ViewTempatMakanPageState createState() => _ViewTempatMakanPageState();
}

class _ViewTempatMakanPageState extends State<ViewTempatMakanPage> {
  late Future<List<QueryDocumentSnapshot>> _tempatMakanDataFuture;

  @override
  void initState() {
    super.initState();
    _tempatMakanDataFuture = _fetchTempatMakanData();
  }

  // Fungsi untuk mengambil data tempat makan dari Firestore
  Future<List<QueryDocumentSnapshot>> _fetchTempatMakanData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tempat_makan').get();
      return snapshot.docs;
    } catch (e) {
      print("Gagal mengambil data tempat makan: $e");
      return [];
    }
  }

  // Fungsi untuk menghapus data tempat makan
  Future<void> _deleteTempatMakan(String tempatMakanId) async {
    try {
      await FirebaseFirestore.instance
          .collection('tempat_makan')
          .doc(tempatMakanId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data tempat makan berhasil dihapus'),
      ));
      setState(() {
        _tempatMakanDataFuture =
            _fetchTempatMakanData(); // Refresh data setelah dihapus
      });
    } catch (e) {
      print("Gagal menghapus data tempat makan: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan saat menghapus data'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF334d2b),
      appBar: AppBar(
        title: Text('Tempat Makan'),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _tempatMakanDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data tempat makan ditemukan'));
          }

          List<QueryDocumentSnapshot> tempatMakanData = snapshot.data!;
          return ListView.builder(
            itemCount: tempatMakanData.length,
            itemBuilder: (context, index) {
              var tempatMakan =
                  tempatMakanData[index].data() as Map<String, dynamic>;
              String desaId = tempatMakan['desa_id']; // Extracting desa_id
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.restaurant,
                      size: 40, color: Color(0xFF334d2b)),
                  title: Text(tempatMakan['nama'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alamat: ${tempatMakan['alamat']}'),
                      Text('Jam Buka: ${tempatMakan['jamBuka']}'),
                      Text('Jam Tutup: ${tempatMakan['jamTutup']}'),
                      Text('Kontak: ${tempatMakan['kontak']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Color(0xFF007BFF),
                        onPressed: () async {
                          // Pass the actual data to the edit page including desa_id
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTempatMakanPage(
                                tempatMakanId: tempatMakanData[index].id,
                                initialData: tempatMakan,
                                desaId: desaId, // Pass desa_id
                              ),
                            ),
                          );
                          setState(() {
                            _tempatMakanDataFuture = _fetchTempatMakanData();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Color.fromARGB(255, 164, 11, 11),
                        onPressed: () async {
                          // Konfirmasi sebelum menghapus
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Konfirmasi Hapus'),
                                content: Text(
                                    'Apakah Anda yakin ingin menghapus tempat makan ini?'),
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
                            await _deleteTempatMakan(tempatMakanData[index].id);
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
      // Floating action button to add a new place
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to the page to add a new place
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahTempatMakanPage(),
            ),
          );
          setState(() {
            _tempatMakanDataFuture = _fetchTempatMakanData();
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Tempat Makan',
        backgroundColor: Color.fromARGB(255, 121, 188, 100),
      ),
    );
  }
}
