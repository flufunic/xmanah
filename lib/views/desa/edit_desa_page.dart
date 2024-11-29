import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/desa.dart';

class EditDesaPage extends StatefulWidget {
  final String desaId; // The ID of the desa to be edited

  EditDesaPage({required this.desaId});

  @override
  _EditDesaPageState createState() => _EditDesaPageState();
}

class _EditDesaPageState extends State<EditDesaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each input field
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _gambarController =
      TextEditingController(); // Controller for image URL

  final DesaService _desaService = DesaService();

  // Function to load existing data from Firestore
  Future<void> _loadDesaData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('desa')
          .doc(widget.desaId)
          .get();

      if (snapshot.exists) {
        var data = snapshot.data() as Map<String, dynamic>;

        _namaController.text = data['nama'] ?? '';
        _kodePosController.text = data['kode_pos'] ?? '';
        _alamatController.text = data['alamat'] ?? '';
        _kontakController.text = data['kontak'] ?? '';
        _gambarController.text =
            data['gambar'] ?? ''; // Load image URL if available
      }
    } catch (e) {
      print("Error loading desa data: $e");
    }
  }

  // Function to update the data in Firestore
  Future<void> _updateDesa() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('desa')
            .doc(widget.desaId)
            .update({
          'nama': _namaController.text,
          'kode_pos': _kodePosController.text,
          'alamat': _alamatController.text,
          'kontak': _kontakController.text,
          'gambar': _gambarController.text, // Include image URL update
        });

        // Show success alert dialog
        _showSuccessDialog();
      } catch (e) {
        print("Error updating desa data: $e");
      }
    }
  }

  // Function to show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Data desa berhasil diperbarui!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Close the alert dialog and navigate to the view page
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context)
                    .pop(); // Go back to the previous page (View page)
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // Load the desa data when the page is first created
    _loadDesaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data Desa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: 'Nama Desa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama desa harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kodePosController,
                decoration: InputDecoration(labelText: 'Kode Pos'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kode pos harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _kontakController,
                decoration: InputDecoration(labelText: 'Kontak'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kontak harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _gambarController, // Input for image URL
                decoration: InputDecoration(labelText: 'URL Gambar'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL gambar harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateDesa,
                child: Text('Update Data Desa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
