import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/kost.dart';
import 'package:xmanah/views/kost/view_kost_page.dart';

class EditKostPage extends StatefulWidget {
  final String kostId; // ID of the Kost to edit

  EditKostPage({required this.kostId});

  @override
  _EditKostPageState createState() => _EditKostPageState();
}

class _EditKostPageState extends State<EditKostPage> {
  final _formKey = GlobalKey<FormState>();

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
    _fetchKostData();
  }

  // Fetch desa data from Firestore
  Future<void> _fetchDesaList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('desa').get();
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem(
          value: doc.id,
          child: Text(doc['nama']),
        );
      }).toList();
      setState(() {
        _desaItems = items;
      });
    } catch (e) {
      print("Gagal mengambil data desa: $e");
    }
  }

  // Fetch existing kost data
  Future<void> _fetchKostData() async {
    try {
      DocumentSnapshot kostSnapshot = await FirebaseFirestore.instance
          .collection('kost')
          .doc(widget.kostId)
          .get();
      if (kostSnapshot.exists) {
        var data = kostSnapshot.data() as Map<String, dynamic>;
        _namaController.text = data['nama'];
        _alamatController.text = data['alamat'];
        _fasilitasController.text = data['fasilitas'];
        _kontakController.text = data['kontak'];
        _hargaController.text = data['harga'].toString();
        _gambarController.text = data['gambar'];
        _selectedDesaId = data['desa_id'];
        setState(() {});
      }
    } catch (e) {
      print("Gagal mengambil data kost: $e");
    }
  }

  Future<void> _updateKost() async {
    if (_formKey.currentState!.validate() && _selectedDesaId != null) {
      await _kostService.updateKost(
        kostId: widget.kostId,
        nama: _namaController.text,
        alamat: _alamatController.text,
        fasilitas: _fasilitasController.text,
        kontak: _kontakController.text,
        harga: int.parse(_hargaController.text),
        gambar: _gambarController.text,
        desaId: _selectedDesaId!,
      );

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sukses!'),
            content: Text('Data kos berhasil diperbarui.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate to the ViewKostPage after successful update
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewKostPage(),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else if (_selectedDesaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih desa terlebih dahulu!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF334d2b), // Set background color to dark green
      appBar: AppBar(
        title: Text('Edit Data Kos'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0), // Small padding for compact design
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12.0), // Slightly smaller radius
          ),
          color: Colors.white, // White background for the card
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(12.0), // Smaller padding inside card
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Text
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        'Edit Data Kost',
                        style: TextStyle(
                          fontSize: 20, // Smaller font size
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334d2b),
                        ),
                      ),
                    ),
                    // Name input with icon
                    _buildTextField(
                      controller: _namaController,
                      label: 'Nama Kos',
                      icon: Icons.home,
                    ),
                    // Address input with icon
                    _buildTextField(
                      controller: _alamatController,
                      label: 'Alamat',
                      icon: Icons.location_on,
                    ),
                    // Facilities input with icon
                    _buildTextField(
                      controller: _fasilitasController,
                      label: 'Fasilitas',
                      icon: Icons.build,
                    ),
                    // Contact input with icon
                    _buildTextField(
                      controller: _kontakController,
                      label: 'Kontak',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    // Price input with icon
                    _buildTextField(
                      controller: _hargaController,
                      label: 'Harga',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                    // Image URL input with icon
                    _buildTextField(
                      controller: _gambarController,
                      label: 'URL Gambar',
                      icon: Icons.image,
                    ),
                    // Dropdown for Desa
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
                          borderRadius: BorderRadius.circular(
                              8), // Slightly smaller border radius
                        ),
                      ),
                      validator: (value) => value == null ? 'Pilih desa' : null,
                    ),
                    SizedBox(height: 16), // Smaller gap before button
                    // Update button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateKost,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF334d2b),
                          padding: EdgeInsets.symmetric(
                              vertical: 14), // Smaller padding
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(8), // Smaller radius
                          ),
                        ),
                        child: Text(
                          'Update Data Kos',
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
    );
  }

  // Helper method to create a text input field with icon
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 12.0), // Smaller gap between fields
      child: Container(
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(8), // Smaller radius for the container
          border: Border.all(color: Colors.grey),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, color: Color(0xFF334d2b)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
                vertical: 12.0, horizontal: 12.0), // Smaller padding
          ),
          keyboardType: keyboardType,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '$label harus diisi';
            }
            return null;
          },
        ),
      ),
    );
  }
}
