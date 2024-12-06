import 'package:flutter/material.dart';
import 'package:xmanah/controller/desa.dart';

class TambahDesaPage extends StatefulWidget {
  @override
  _TambahDesaPageState createState() => _TambahDesaPageState();
}

class _TambahDesaPageState extends State<TambahDesaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk masing-masing field
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _kodePosController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();

  final DesaService _desaService = DesaService();

  Future<void> _simpanDesa() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Menyimpan data desa
        await _desaService.tambahDesa(
          nama: _namaController.text,
          kodePos: _kodePosController.text,
          alamat: _alamatController.text,
          kontak: _kontakController.text,
          gambar: _gambarController.text,
        );

        // Menampilkan dialog sukses
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sukses'),
              content: Text('Data desa berhasil ditambahkan!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    _namaController.clear();
                    _kodePosController.clear();
                    _alamatController.clear();
                    _kontakController.clear();
                    _gambarController.clear();
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        // Menampilkan dialog error
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Gagal menyimpan data desa!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF334d2b),
      appBar: AppBar(
        backgroundColor: Color(0xFF334d2b),
        title: Text('Tambah Data Desa'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tambah Data Desa',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF334d2b),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _namaController,
                      label: 'Nama Desa',
                      icon: Icons.location_city,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _kodePosController,
                      label: 'Kode Pos',
                      icon: Icons.markunread_mailbox_outlined,
                      inputType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _alamatController,
                      label: 'Alamat Balai Desa',
                      icon: Icons.place,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _kontakController,
                      label: 'Kontak',
                      icon: Icons.phone,
                      inputType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _gambarController,
                      label: 'URL Gambar',
                      icon: Icons.image,
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF334d2b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: _simpanDesa,
                      child: Text(
                        'Simpan Data Desa',
                        style: TextStyle(fontSize: 18, color: Colors.white),
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
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label harus diisi';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF334d2b)),
        labelStyle: TextStyle(color: Color(0xFF334d2b)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF334d2b)),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
