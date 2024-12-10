import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/desa.dart';

class EditDesaPage extends StatefulWidget {
  final String desaId;

  EditDesaPage({required this.desaId});

  @override
  _EditDesaPageState createState() => _EditDesaPageState();
}

class _EditDesaPageState extends State<EditDesaPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();
  final DesaService _desaService = DesaService();

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
        _gambarController.text = data['gambar'] ?? '';
      }
    } catch (e) {
      print("Error loading desa data: $e");
    }
  }

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
          'gambar': _gambarController.text,
        });
        _showSuccessDialog();
      } catch (e) {
        print("Error updating desa data: $e");
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text('Data desa berhasil diperbarui!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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
    _loadDesaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF334d2b),
      appBar: AppBar(
        title: Text('Edit Data Desa'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Edit Data Desa",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF334d2b),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                        controller: _namaController,
                        label: 'Nama Desa',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama desa harus diisi';
                          }
                          return null;
                        }),
                    SizedBox(height: 10),
                    _buildTextField(
                        controller: _kodePosController,
                        label: 'Kode Pos',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kode pos harus diisi';
                          }
                          return null;
                        }),
                    SizedBox(height: 10),
                    _buildTextField(
                        controller: _alamatController,
                        label: 'Alamat Balai Desa',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alamat harus diisi';
                          }
                          return null;
                        }),
                    SizedBox(height: 10),
                    _buildTextField(
                        controller: _kontakController,
                        label: 'Kontak',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kontak harus diisi';
                          }
                          return null;
                        }),
                    SizedBox(height: 10),
                    _buildTextField(
                        controller: _gambarController,
                        label: 'URL Gambar',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'URL gambar harus diisi';
                          }
                          return null;
                        }),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateDesa,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF334d2b),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: Text(
                        'Update Data Desa',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      validator: validator,
    );
  }
}
