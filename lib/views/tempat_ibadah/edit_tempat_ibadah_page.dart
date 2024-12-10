import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTempatIbadahPage extends StatefulWidget {
  final String tempatIbadahId;

  EditTempatIbadahPage({required this.tempatIbadahId});

  @override
  _EditTempatIbadahPageState createState() => _EditTempatIbadahPageState();
}

class _EditTempatIbadahPageState extends State<EditTempatIbadahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController gambarController = TextEditingController();
  final TextEditingController jamBukaController = TextEditingController();
  final TextEditingController jamTutupController = TextEditingController();

  String selectedKategori = 'Masjid';
  String? selectedDesaId;
  List<DropdownMenuItem<String>> desaItems = [];

  List<String> kategoriOptions = [
    'Masjid',
    'Klenteng',
    'Vihara',
    'Gereja',
    'Pura',
  ];

  @override
  void initState() {
    super.initState();
    _fetchDesaList();
    _loadTempatIbadahData();
  }

  // Fetch desa list for dropdown
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
        desaItems = items;
      });
    } catch (e) {
      print("Gagal mengambil data desa: $e");
    }
  }

  // Load existing Tempat Ibadah data
  Future<void> _loadTempatIbadahData() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('tempat_ibadah')
          .doc(widget.tempatIbadahId)
          .get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;

        namaController.text = data['nama'];
        alamatController.text = data['alamat'];
        kontakController.text = data['kontak'];
        gambarController.text = data['gambar'];
        selectedKategori = data['kategori'];
        selectedDesaId = data['desa_id'];

        // Set time format for Jam Buka and Jam Tutup
        var jamBukaStr = data['jamBuka'].split(':');
        jamBukaController.text = '${jamBukaStr[0]}:${jamBukaStr[1]}';

        var jamTutupStr = data['jamTutup'].split(':');
        jamTutupController.text = '${jamTutupStr[0]}:${jamTutupStr[1]}';

        setState(() {});
      }
    } catch (e) {
      print("Gagal memuat data tempat ibadah: $e");
    }
  }

  // Save the edited Tempat Ibadah
  void updateTempatIbadah() async {
    if (_formKey.currentState!.validate() && selectedDesaId != null) {
      try {
        // Updating the existing document in Firestore using the tempatIbadahId passed to this page
        await FirebaseFirestore.instance
            .collection('tempat_ibadah')
            .doc(widget.tempatIbadahId)
            .update({
          'nama': namaController.text,
          'kategori': selectedKategori,
          'alamat': alamatController.text,
          'jamBuka': jamBukaController.text,
          'jamTutup': jamTutupController.text,
          'kontak': kontakController.text,
          'gambar': gambarController.text,
          'desa_id': selectedDesaId,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data tempat ibadah berhasil diperbarui'),
        ));

        Navigator.pop(context); // Go back to the previous page
      } catch (e) {
        print("Gagal memperbarui tempat ibadah: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Terjadi kesalahan saat memperbarui data'),
        ));
      }
    }
  }

  // Time picker for Jam Buka and Jam Tutup
  Future<void> _selectJam(BuildContext context, String field) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: field == 'jamBuka'
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        if (field == 'jamBuka') {
          jamBukaController.text = picked.format(context);
        } else {
          jamTutupController.text = picked.format(context);
        }
      });
    }
  }

  // Build the form for dropdown fields
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF334d2b)),
        border: OutlineInputBorder(),
      ),
      onChanged: onChanged,
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF334d2b), // Set background color
      appBar: AppBar(
        title: Text('Edit Data Tempat Ibadah'),
        backgroundColor:
            Color.fromARGB(255, 255, 255, 255), // Set AppBar background color
      ),
      body: SingleChildScrollView(
        // Make the entire form scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Edit Data Tempat Ibadah',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF334d2b),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Tempat Ibadah',
                        prefixIcon:
                            Icon(Icons.location_city, color: Color(0xFF334d2b)),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Nama tempat ibadah harus diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: alamatController,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        prefixIcon:
                            Icon(Icons.location_on, color: Color(0xFF334d2b)),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Alamat harus diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: kontakController,
                      decoration: InputDecoration(
                        labelText: 'Kontak',
                        prefixIcon: Icon(Icons.phone, color: Color(0xFF334d2b)),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Kontak harus diisi';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: gambarController,
                      decoration: InputDecoration(
                        labelText: 'URL Gambar',
                        prefixIcon: Icon(Icons.image, color: Color(0xFF334d2b)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Kategori',
                      value: selectedKategori,
                      icon: Icons.category,
                      items: kategoriOptions
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedKategori = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    _buildDropdownField(
                      label: 'Desa',
                      value: selectedDesaId,
                      icon: Icons.place,
                      items: desaItems,
                      onChanged: (value) {
                        setState(() {
                          selectedDesaId = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: jamBukaController,
                      decoration: InputDecoration(
                        labelText: 'Jam Buka',
                        prefixIcon:
                            Icon(Icons.access_time, color: Color(0xFF334d2b)),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {
                        _selectJam(context, 'jamBuka');
                      },
                      readOnly: true,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: jamTutupController,
                      decoration: InputDecoration(
                        labelText: 'Jam Tutup',
                        prefixIcon:
                            Icon(Icons.access_time, color: Color(0xFF334d2b)),
                        border: OutlineInputBorder(),
                      ),
                      onTap: () {
                        _selectJam(context, 'jamTutup');
                      },
                      readOnly: true,
                    ),
                    SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: updateTempatIbadah,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF334d2b),
                        foregroundColor: Color.fromARGB(
                            255, 255, 255, 255), // Button background color
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Update Tempat Ibadah',
                        style: TextStyle(fontSize: 16),
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
}
