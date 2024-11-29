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
  final TextEditingController _gambarController =
      TextEditingController(); // Controller untuk URL gambar

  final DesaService _desaService = DesaService();

  Future<void> _simpanDesa() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Menyimpan data desa menggunakan layanan DesaService
        await _desaService.tambahDesa(
          nama: _namaController.text,
          kodePos: _kodePosController.text,
          alamat: _alamatController.text,
          kontak: _kontakController.text,
          gambar: _gambarController.text, // Menambahkan gambar URL
        );

        // Menampilkan dialog sukses setelah berhasil menyimpan data
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
                    // Clear the form fields after saving
                    _namaController.clear();
                    _kodePosController.clear();
                    _alamatController.clear();
                    _kontakController.clear();
                    _gambarController.clear(); // Clear gambar URL field

                    // Close the alert dialog
                    Navigator.of(context).pop();

                    // Navigate back to the previous page (DesaViewPage)
                    Navigator.pop(
                        context); // This navigates back to the previous screen
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print("Error saving desa data: $e");

        // Show error message if data saving fails
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
                    Navigator.of(context).pop(); // Close the dialog
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
      appBar: AppBar(
        title: Text('Tambah Data Desa'),
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
                controller: _gambarController, // Input untuk URL gambar
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
                onPressed: _simpanDesa,
                child: Text('Simpan Data Desa'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
