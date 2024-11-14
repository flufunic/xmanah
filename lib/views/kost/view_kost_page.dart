import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_kost_page.dart';
import 'tambah_kost_page.dart'; // Import the page for adding new kost data

class ViewKostPage extends StatefulWidget {
  @override
  _ViewKostPageState createState() => _ViewKostPageState();
}

class _ViewKostPageState extends State<ViewKostPage> {
  late Future<List<QueryDocumentSnapshot>> _kostDataFuture;

  @override
  void initState() {
    super.initState();
    _kostDataFuture = _fetchKostData();
  }

  // Fetch data from Firestore
  Future<List<QueryDocumentSnapshot>> _fetchKostData() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('kost').get();
      return snapshot.docs;
    } catch (e) {
      print("Gagal mengambil data kost: $e");
      return [];
    }
  }

  // Delete kost from Firestore
  Future<void> _deleteKost(String kostId) async {
    try {
      await FirebaseFirestore.instance.collection('kost').doc(kostId).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Kost berhasil dihapus'),
      ));
      setState(() {
        _kostDataFuture = _fetchKostData();
      });
    } catch (e) {
      print("Gagal menghapus data kost: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Gagal menghapus data kost'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Kost'),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _kostDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data kost ditemukan'));
          }

          List<QueryDocumentSnapshot> kostData = snapshot.data!;
          return ListView.builder(
            itemCount: kostData.length,
            itemBuilder: (context, index) {
              var kost = kostData[index].data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.home, size: 40),
                  title: Text(kost['nama'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Alamat: ${kost['alamat']}'),
                      Text('Harga: Rp ${kost['harga']}'),
                      Text('Kontak: ${kost['kontak']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          // After the user edits the kost, refresh the data
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditKostPage(kostId: kostData[index].id),
                            ),
                          );

                          // After returning from the edit page, re-fetch the data
                          setState(() {
                            _kostDataFuture = _fetchKostData();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          // Confirm deletion
                          bool? confirmDelete = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Konfirmasi Hapus'),
                              content: Text(
                                  'Apakah Anda yakin ingin menghapus kost ini?'),
                              actions: [
                                TextButton(
                                  child: Text('Batal'),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                TextButton(
                                  child: Text('Hapus'),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ],
                            ),
                          );

                          if (confirmDelete == true) {
                            // If confirmed, delete the kost
                            await _deleteKost(kostData[index].id);
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
          // Navigate to the TambahKostPage to add a new kost entry
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahKostPage()),
          );

          // Refresh the kost data after adding a new entry
          setState(() {
            _kostDataFuture = _fetchKostData();
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Tambah Kost',
      ),
    );
  }
}
