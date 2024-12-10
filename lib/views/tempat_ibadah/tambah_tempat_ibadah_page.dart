import 'package:flutter/material.dart';
import 'package:xmanah/controller/tempat_ibadah.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view_tempat_ibadah_page.dart'; // Import ViewTempatIbadahPage

class TambahTempatIbadahPage extends StatefulWidget {
  @override
  _TambahTempatIbadahPageState createState() => _TambahTempatIbadahPageState();
}

class _TambahTempatIbadahPageState extends State<TambahTempatIbadahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk masing-masing field
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController gambarController = TextEditingController();

  TimeOfDay? jamBuka; // Jam Buka menggunakan TimeOfDay
  TimeOfDay? jamTutup; // Jam Tutup menggunakan TimeOfDay

  String selectedKategori = 'Masjid'; // Default value untuk kategori
  String? selectedDesaId; // Desa ID yang dipilih
  List<DropdownMenuItem<String>> desaItems = []; // Dropdown desa

  List<String> kategoriOptions = [
    'Masjid',
    'Klenteng',
    'Vihara',
    'Gereja',
    'Pura'
  ]; // Opsi kategori

  final TempatIbadahService tempatIbadahService = TempatIbadahService();

  @override
  void initState() {
    super.initState();
    _fetchDesaList(); // Load the desa list when the page is initialized
  }

  // Fetch desa data from Firestore and populate dropdown items
  Future<void> _fetchDesaList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('desa').get();
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem(
          value: doc.id,
          child: Text(doc['nama']), // Menampilkan nama desa dalam dropdown
        );
      }).toList();
      setState(() {
        desaItems = items;
      });
    } catch (e) {
      print("Gagal mengambil data desa: $e");
    }
  }

  // Fungsi untuk memilih waktu jam buka
  Future<void> _selectJamBuka(BuildContext context) async {
    TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ))!;
    setState(() {
      jamBuka = picked;
    });
  }

  // Fungsi untuk memilih waktu jam tutup
  Future<void> _selectJamTutup(BuildContext context) async {
    TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ))!;
    setState(() {
      jamTutup = picked;
    });
  }

  // Fungsi untuk menambahkan tempat ibadah
  void tambahTempatIbadah() async {
    if (_formKey.currentState!.validate() &&
        jamBuka != null &&
        jamTutup != null &&
        selectedDesaId != null) {
      try {
        await tempatIbadahService.tambahTempatIbadah(
          nama: namaController.text,
          kategori: selectedKategori,
          alamat: alamatController.text,
          jamBuka: jamBuka!,
          jamTutup: jamTutup!,
          kontak: kontakController.text,
          gambar: gambarController.text,
          desaId: selectedDesaId!, // Menambahkan desaId
        );

        // Reset form setelah berhasil
        setState(() {
          namaController.clear();
          alamatController.clear();
          kontakController.clear();
          gambarController.clear();
          jamBuka = null;
          jamTutup = null;
          selectedKategori = 'Masjid'; // Reset kategori ke default
          selectedDesaId = null; // Reset desaId
        });

        // Tampilkan alert dialog setelah data berhasil ditambahkan
        _showSuccessDialog();
      } catch (e) {
        // Tampilkan error dialog jika terjadi kesalahan
        _showErrorDialog(e.toString());
      }
    }
  }

  // Function to show success dialog and navigate to ViewTempatIbadahPage
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text('Tempat Ibadah berhasil ditambahkan!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewTempatIbadahPage(), // Navigate to View page
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Function to show error dialog
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
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
      backgroundColor: Color(0xFF334d2b), // Background color
      appBar: AppBar(
        title: Text("Tambah Data Tempat Ibadah"),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView to handle overflow
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.white, // Card color
          elevation: 5, // Card shadow
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Data Tempat Ibadah',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334d2b), // Text color
                    ),
                  ),
                  SizedBox(height: 20),
                  // Nama Tempat Ibadah
                  _buildTextField(
                    controller: namaController,
                    label: 'Nama Tempat Ibadah',
                    icon: Icons.place,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tempat ibadah harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Alamat
                  _buildTextField(
                    controller: alamatController,
                    label: 'Alamat',
                    icon: Icons.location_on,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Alamat harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Kategori
                  _buildDropdownField(
                    value: selectedKategori,
                    label: 'Pilih Kategori',
                    icon: Icons.category,
                    items: kategoriOptions,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedKategori = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih kategori terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Jam Buka
                  _buildTimePickerField(
                    label: 'Jam Buka',
                    onTap: () => _selectJamBuka(context),
                    selectedTime: jamBuka,
                    placeholder: 'Pilih Jam Buka',
                  ),
                  SizedBox(height: 10),
                  // Jam Tutup
                  _buildTimePickerField(
                    label: 'Jam Tutup',
                    onTap: () => _selectJamTutup(context),
                    selectedTime: jamTutup,
                    placeholder: 'Pilih Jam Tutup',
                  ),
                  SizedBox(height: 10),
                  // Kontak
                  _buildTextField(
                    controller: kontakController,
                    label: 'Kontak',
                    icon: Icons.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kontak harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Gambar URL
                  _buildTextField(
                    controller: gambarController,
                    label: 'Gambar URL',
                    icon: Icons.image,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Gambar URL harus diisi';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  // Desa
                  DropdownButtonFormField<String>(
                    value: selectedDesaId,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDesaId = newValue;
                      });
                    },
                    items: desaItems,
                    decoration: InputDecoration(
                      labelText: 'Pilih Desa',
                      prefixIcon: Icon(Icons.home, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih desa terlebih dahulu';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: tambahTempatIbadah,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF334d2b), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Tambah Tempat Ibadah',
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
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: (String? newValue) => onChanged(newValue),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildTimePickerField({
    required String label,
    required VoidCallback onTap,
    required TimeOfDay? selectedTime,
    required String placeholder,
  }) {
    return InkWell(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: label,
            hintText: selectedTime != null
                ? selectedTime!.format(context)
                : placeholder,
            prefixIcon: Icon(Icons.access_time),
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
