import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';
import 'package:xmanah/views/lembaga_pendidikan/view_lembaga_pendidikan_page.dart';

class TambahLembagaPendidikanPage extends StatefulWidget {
  @override
  _TambahLembagaPendidikanPageState createState() =>
      _TambahLembagaPendidikanPageState();
}

class _TambahLembagaPendidikanPageState
    extends State<TambahLembagaPendidikanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController gambarController = TextEditingController();

  String selectedAkreditasi = 'A'; // Default value
  String selectedTingkat = 'SD'; // Default value
  String? selectedDesaId; // To store selected desa_id
  List<DropdownMenuItem<String>> desaItems = []; // List for desa dropdown

  List<String> akreditasiOptions = ['Unggul', 'A', 'B', 'C'];
  List<String> tingkatOptions = ['SD', 'SMP', 'SMA/K', 'Universitas'];

  final LembagaPendidikanService lembagaService = LembagaPendidikanService();

  void tambahLembaga() async {
    try {
      if (selectedDesaId != null) {
        await lembagaService.tambahLembagaPendidikan(
          nama: namaController.text,
          alamat: alamatController.text,
          akreditasi: selectedAkreditasi,
          tingkat: selectedTingkat,
          kontak: kontakController.text,
          gambar: gambarController.text,
          desaId: selectedDesaId!,
        );

        setState(() {
          namaController.clear();
          alamatController.clear();
          kontakController.clear();
          gambarController.clear();
          selectedAkreditasi = 'A';
          selectedTingkat = 'SD';
          selectedDesaId = null; // Clear selected desa
        });

        _showSuccessDialog();
      } else {
        _showErrorDialog("Pilih desa terlebih dahulu!");
      }
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _fetchDesaList() async {
    try {
      // Mengambil data dari koleksi desa
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('desa').get();

      // Menyusun items dropdown dengan menggunakan field 'nama'
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem<String>(
          value: doc.id, // Menyimpan ID sebagai nilai
          child:
              Text(doc['nama'] ?? 'Tidak Diketahui'), // Menampilkan nama desa
        );
      }).toList();

      setState(() {
        desaItems = items;
      });
    } catch (e) {
      print("Gagal mengambil data desa: $e");
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text('Lembaga Pendidikan berhasil ditambahkan!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewLembagaPendidikanPage(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildImagePreview(String imageUrl) {
    if (imageUrl.isNotEmpty &&
        Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Image.network(
          imageUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDesaList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF334d2b),
      appBar: AppBar(
        title: Text("Tambah Data Lembaga Pendidikan"),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tambah Data Lembaga Pendidikan',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF334d2b)),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: namaController,
                    hint: 'Nama Lembaga',
                    icon: Icons.school,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: alamatController,
                    hint: 'Alamat',
                    icon: Icons.location_on,
                  ),
                  SizedBox(height: 15),
                  _buildDropdownWithHint(
                    hint: 'Pilih Akreditasi',
                    value: selectedAkreditasi,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedAkreditasi = newValue!;
                      });
                    },
                    items: akreditasiOptions,
                    icon: Icons.grade,
                  ),
                  SizedBox(height: 15),
                  _buildDropdownWithHint(
                    hint: 'Pilih Tingkat',
                    value: selectedTingkat,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTingkat = newValue!;
                      });
                    },
                    items: tingkatOptions,
                    icon: Icons.school_outlined,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: kontakController,
                    hint: 'Kontak',
                    icon: Icons.phone,
                  ),
                  SizedBox(height: 15),
                  _buildTextField(
                    controller: gambarController,
                    hint: 'Gambar (URL)',
                    icon: Icons.image,
                  ),
                  _buildImagePreview(gambarController.text),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedDesaId,
                    items: desaItems,
                    onChanged: (value) {
                      setState(() {
                        selectedDesaId = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.map, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(),
                    ),
                    hint: Text(
                      'Pilih Desa',
                      style: TextStyle(fontSize: 16, color: Color(0xFF334d2b)),
                    ),
                    isExpanded: true,
                  ),
                  SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: tambahLembaga,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF334d2b), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Tambah Lembaga Pendidikan',
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
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFF334d2b)), // Icon color changed
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdownWithHint({
    required String hint,
    required String? value,
    required Function(String?) onChanged,
    required List<String> items,
    required IconData icon,
  }) {
    return SizedBox(
      height: 50,
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        items: items.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        decoration: InputDecoration(
          prefixIcon:
              Icon(icon, color: Color(0xFF334d2b)), // Icon color changed
          border: OutlineInputBorder(),
        ),
        hint: Text(
          hint,
          style: TextStyle(fontSize: 16, color: Color(0xFF334d2b)),
        ),
        style: TextStyle(fontSize: 16, color: Color(0xFF334d2b)),
      ),
    );
  }
}
