import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_desa_page.dart'; // Import the EditDesaPage for editing specific village details
import 'tambah_desa_page.dart'; // Import the page for adding new village data

class DesaViewPage extends StatelessWidget {
  final CollectionReference desaCollection =
      FirebaseFirestore.instance.collection('desa');

  BuildContext? get context => null;

  // Function to load and display all desa (village) data
  Future<void> _showDesaDetails(BuildContext context, String desaId) async {
    // Fetch the village data using the ID
    DocumentSnapshot snapshot = await desaCollection.doc(desaId).get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;

      // Navigate to the edit page with the desaId to edit the specific desa
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditDesaPage(desaId: desaId),
        ),
      );
    }
  }

  // Function to delete a specific desa (village) by its ID
  Future<void> _deleteDesa(String desaId) async {
    try {
      // Perform the delete action
      await desaCollection.doc(desaId).delete();
      print("Data desa berhasil dihapus!");

      // Show success message
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(content: Text('Data desa berhasil dihapus!')),
      );
    } catch (e) {
      print("Gagal menghapus data desa: $e");
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data desa.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Desa'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: desaCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada data desa.'));
          }

          // Fetch and display the list of desa (village) data
          var desaData = snapshot.data!.docs;

          return ListView.builder(
            itemCount: desaData.length,
            itemBuilder: (context, index) {
              var desa = desaData[index];
              var nama = desa['nama'];
              var kodePos = desa['kode_pos'];
              var alamat = desa['alamat'];
              var kontak = desa['kontak'];
              String desaId = desa.id; // Document ID for the specific desa

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: Icon(Icons.home, color: Colors.blue), // Icon rumah
                  title: Text(nama),
                  subtitle:
                      Text('$alamat\nKode Pos: $kodePos\nKontak: $kontak'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _showDesaDetails(context, desaId),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Show a confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Hapus Data Desa'),
                                content: Text(
                                    'Apakah Anda yakin ingin menghapus desa ini?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Batal'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Hapus'),
                                    onPressed: () {
                                      _deleteDesa(desaId); // Delete desa
                                      Navigator.of(context)
                                          .pop(); // Close dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
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
      // Floating Action Button (FAB) for adding new Desa
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the page to add new desa
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahDesaPage(), // Page to add new desa
            ),
          );
        },
        child: Icon(Icons.add), // Icon for the button
        tooltip: 'Tambah Desa',
        backgroundColor: Colors.blue, // FAB background color
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Position the FAB at the bottom-right
    );
  }
}
