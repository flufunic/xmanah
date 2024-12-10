import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/kost.dart';

class TambahKostPage extends StatefulWidget {
  @override
  _TambahKostPageState createState() => _TambahKostPageState();
}

class _TambahKostPageState extends State<TambahKostPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk masing-masing field
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _fasilitasController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();

  final KostService _kostService = KostService();

  String? _selectedDesaId;
  List<DropdownMenuItem<String>> _desaItems = [];

  @override
  void initState() {
    super.initState();
    _fetchDesaList();
  }

  // Fetch desa data from Firestore and populate dropdown items
  Future<void> _fetchDesaList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('desa').get();
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem(
          value: doc.id,
          child: Text(doc['nama']), // menampilkan nama desa dalam dropdown
        );
      }).toList();
      setState(() {
        _desaItems = items;
      });
    } catch (e) {
      print("Gagal mengambil data desa: $e");
    }
  }

  Future<void> _simpanKost() async {
    if (_formKey.currentState!.validate() && _selectedDesaId != null) {
      await _kostService.tambahKost(
        nama: _namaController.text,
        alamat: _alamatController.text,
        fasilitas: _fasilitasController.text,
        kontak: _kontakController.text,
        harga: int.parse(_hargaController.text),
        gambar: _gambarController.text,
        desaId: _selectedDesaId!,
      );

      // Show success alert dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Sukses'),
          content: Text('Data kos berhasil ditambahkan!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(true); // Return to the previous page
              },
              child: Text('OK'),
            ),
          ],
        ),
      );

      // Bersihkan form setelah menyimpan
      _namaController.clear();
      _alamatController.clear();
      _fasilitasController.clear();
      _kontakController.clear();
      _hargaController.clear();
      _gambarController.clear();
      setState(() {
        _selectedDesaId = null;
      });
    } else if (_selectedDesaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih desa terlebih dahulu!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Kos'),
        backgroundColor:
            Color.fromARGB(255, 255, 255, 255), // app bar background color
      ),
      body: Container(
        color: Color(0xFF334d2b), // Set background color to green
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title for the form
                      Text(
                        'Tambah Data Kost',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334d2b), // Text color
                        ),
                      ),
                      SizedBox(height: 16),

                      // Nama Kost
                      _buildTextField(
                        controller: _namaController,
                        label: 'Nama Kos',
                        icon: Icons.home,
                      ),
                      SizedBox(height: 16),

                      // Alamat
                      _buildTextField(
                        controller: _alamatController,
                        label: 'Alamat',
                        icon: Icons.location_on,
                      ),
                      SizedBox(height: 16),

                      // Fasilitas
                      _buildTextField(
                        controller: _fasilitasController,
                        label: 'Fasilitas',
                        icon: Icons.settings,
                      ),
                      SizedBox(height: 16),

                      // Kontak
                      _buildTextField(
                        controller: _kontakController,
                        label: 'Kontak',
                        icon: Icons.phone,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16),

                      // Harga
                      _buildTextField(
                        controller: _hargaController,
                        label: 'Harga',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 16),

                      // URL Gambar
                      _buildTextField(
                        controller: _gambarController,
                        label: 'URL Gambar',
                        icon: Icons.image,
                      ),
                      SizedBox(height: 16),

                      // Dropdown Desa
                      DropdownButtonFormField<String>(
                        value: _selectedDesaId,
                        items: _desaItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedDesaId = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Desa',
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) =>
                            value == null ? 'Pilih desa' : null,
                      ),
                      SizedBox(height: 20),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _simpanKost,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF334d2b), // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Simpan Data Kos',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
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
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label harus diisi';
        }
        return null;
      },
    );
  }
}
