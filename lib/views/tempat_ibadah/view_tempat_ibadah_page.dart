import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_tempat_ibadah_page.dart'; // Edit page import
import 'tambah_tempat_ibadah_page.dart'; // Import the Add Tempat Ibadah page

class ViewTempatIbadahPage extends StatefulWidget {
  @override
  _ViewTempatIbadahPageState createState() => _ViewTempatIbadahPageState();
}

class _ViewTempatIbadahPageState extends State<ViewTempatIbadahPage> {
  late Future<List<QueryDocumentSnapshot>> _tempatIbadahDataFuture;

  @override
  void initState() {
    super.initState();
    _tempatIbadahDataFuture = _fetchTempatIbadahData();
  }

  // Fetch data from Firestore
  Future<List<QueryDocumentSnapshot>> _fetchTempatIbadahData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('tempat_ibadah').get();
      return snapshot.docs;
    } catch (e) {
      print("Gagal mengambil data tempat ibadah: $e");
      return [];
    }
  }

  // Function to delete a tempat ibadah
  Future<void> _deleteTempatIbadah(String tempatIbadahId) async {
    try {
      await FirebaseFirestore.instance
          .collection('tempat_ibadah')
          .doc(tempatIbadahId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Data tempat ibadah berhasil dihapus'),
      ));
      setState(() {
        _tempatIbadahDataFuture =
            _fetchTempatIbadahData(); // Refresh data after deletion
      });
    } catch (e) {
      print("Gagal menghapus data tempat ibadah: $e");
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
        title: Text('Tempat Ibadah'),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _tempatIbadahDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('Tidak ada data tempat ibadah ditemukan'));
          }

          List<QueryDocumentSnapshot> tempatIbadahData = snapshot.data!;
          return ListView.builder(
            itemCount: tempatIbadahData.length,
            itemBuilder: (context, index) {
              var tempatIbadah = tempatIbadahData[index].data()
                  as Map<String, dynamic>; // Cast data to Map
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading:
                      Icon(Icons.place, size: 40, color: Color(0xFF334d2b)),
                  title: Text(tempatIbadah['nama'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kategori: ${tempatIbadah['kategori']}'),
                      Text('Alamat: ${tempatIbadah['alamat']}'),
                      Text('Jam Buka: ${tempatIbadah['jamBuka']}'),
                      Text('Jam Tutup: ${tempatIbadah['jamTutup']}'),
                      Text('Kontak: ${tempatIbadah['kontak']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Color(0xFF007BFF),
                        onPressed: () async {
                          // Navigate to edit page
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditTempatIbadahPage(
                                tempatIbadahId:
                                    tempatIbadahData[index].id, // Pass ID
                              ),
                            ),
                          );
                          setState(() {
                            _tempatIbadahDataFuture = _fetchTempatIbadahData();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Color.fromARGB(255, 164, 11, 11),
                        onPressed: () async {
                          // Confirmation dialog before deleting
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Konfirmasi Hapus'),
                                content: Text(
                                    'Apakah Anda yakin ingin menghapus tempat ibadah ini?'),
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
                            await _deleteTempatIbadah(
                                tempatIbadahData[index].id);
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
        onPressed: () {
          // Navigate to the "Tambah Tempat Ibadah" page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahTempatIbadahPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Tempat Ibadah',
        backgroundColor: Color.fromARGB(255, 121, 188, 100),
      ),
    );
  }
}
