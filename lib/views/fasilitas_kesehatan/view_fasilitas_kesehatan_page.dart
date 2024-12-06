import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/views/fasilitas_kesehatan/edit_fasilitas_kesehatan_page.dart';
import 'package:xmanah/views/fasilitas_kesehatan/tambah_fasilitas_kesehatan_page.dart';

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
      backgroundColor: Color(0xFF334d2b),
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

              // URL gambar
              String imageUrl = fasilitas['imageUrl'] ??
                  ''; // Ambil URL gambar dari Firestore

              return Card(
                color: const Color.fromARGB(255, 255, 255, 255),
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.local_hospital,
                      size: 40, color: Color(0xFF334d2b)),
                  title: Text(fasilitas['nama'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alamat: ${fasilitas['alamat']}'),
                      Text('Jenis: ${fasilitas['jenis']}'),
                      Text('Kontak: ${fasilitas['kontak']}'),
                      // Menampilkan gambar jika URL tersedia
                      imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl, // Menampilkan gambar dari URL
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : SizedBox(), // Jika tidak ada URL, tidak tampilkan gambar
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        color: Color(0xFF007BFF),
                        icon: Icon(Icons.edit),
                        onPressed: () async {
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
                        color: Color.fromARGB(255, 164, 11, 11),
                        onPressed: () async {
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: Text('Konfirmasi Hapus'),
                                content: Text(
                                    'Apakah Anda yakin ingin menghapus fasilitas ini?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(false);
                                    },
                                    child: Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(dialogContext).pop(true);
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
      // Floating Action Button (FAB) untuk menambah data fasilitas kesehatan
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahFasilitasKesehatanPage(),
            ),
          );
          setState(() {
            _fasilitasDataFuture = _fetchFasilitasData(); // Refresh data
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Fasilitas Kesehatan',
        backgroundColor: Color.fromARGB(255, 121, 188, 100),
      ),
    );
  }
}
