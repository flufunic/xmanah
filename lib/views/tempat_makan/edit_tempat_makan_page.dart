import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTempatMakanPage extends StatefulWidget {
  final String tempatMakanId;
  final Map<String, dynamic> initialData;
  final String desaId; // Add desaId to this page

  EditTempatMakanPage({
    required this.tempatMakanId,
    required this.initialData,
    required this.desaId, // Pass desaId
  });

  @override
  _EditTempatMakanPageState createState() => _EditTempatMakanPageState();
}

class _EditTempatMakanPageState extends State<EditTempatMakanPage> {
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController kontakController;
  late TextEditingController jamBukaController;
  late TextEditingController jamTutupController;
  late TextEditingController ulasanController;

  String? selectedDesaId; // Selected desaId for dropdown
  List<DropdownMenuItem<String>> desaItems =
      []; // List of desa items for dropdown

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.initialData['nama']);
    alamatController =
        TextEditingController(text: widget.initialData['alamat']);
    kontakController =
        TextEditingController(text: widget.initialData['kontak']);
    jamBukaController =
        TextEditingController(text: widget.initialData['jamBuka']);
    jamTutupController =
        TextEditingController(text: widget.initialData['jamTutup']);
    ulasanController =
        TextEditingController(text: widget.initialData['ulasan']);
    selectedDesaId = widget.desaId; // Set initial selected desaId
    _fetchDesaList(); // Fetch desa list from Firestore
  }

  // Function to fetch desa list from Firestore
  Future<void> _fetchDesaList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('desa').get();
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem<String>(
          value: doc.id,
          child: Text(doc['nama']), // Display desa name in dropdown
        );
      }).toList();
      setState(() {
        desaItems = items;
      });
    } catch (e) {
      print("Error fetching desa list: $e");
    }
  }

  // Update function with selected desaId
  Future<void> _updateTempatMakan() async {
    if (selectedDesaId == null) {
      _showErrorDialog("Desa harus dipilih.");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('tempat_makan')
          .doc(widget.tempatMakanId)
          .update({
        'nama': namaController.text,
        'alamat': alamatController.text,
        'kontak': kontakController.text,
        'jamBuka': jamBukaController.text,
        'jamTutup': jamTutupController.text,
        'ulasan': ulasanController.text,
        'desa_id': selectedDesaId, // Include selected desa_id in the update
      });
      Navigator.pop(context); // Close after successful update
    } catch (e) {
      print("Error updating tempat makan: $e");
      _showErrorDialog("Gagal memperbarui tempat makan.");
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Tempat Makan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Tempat Makan')),
            TextField(
                controller: alamatController,
                decoration: InputDecoration(labelText: 'Alamat')),
            TextField(
                controller: kontakController,
                decoration: InputDecoration(labelText: 'Kontak')),
            TextField(
                controller: jamBukaController,
                decoration: InputDecoration(labelText: 'Jam Buka')),
            TextField(
                controller: jamTutupController,
                decoration: InputDecoration(labelText: 'Jam Tutup')),
            TextField(
                controller: ulasanController,
                decoration: InputDecoration(labelText: 'Ulasan')),

            // Dropdown for desa_id
            DropdownButtonFormField<String>(
              value: selectedDesaId,
              items: desaItems,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDesaId = newValue;
                });
              },
              decoration: InputDecoration(labelText: 'Pilih Desa'),
              isExpanded: true, // Full-width dropdown
              validator: (value) {
                if (value == null) {
                  return 'Desa harus dipilih';
                }
                return null;
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateTempatMakan,
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}
