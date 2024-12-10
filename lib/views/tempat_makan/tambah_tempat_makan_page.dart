import 'package:flutter/material.dart';
import 'package:xmanah/controller/tempat_makan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view_tempat_makan_page.dart';

class TambahTempatMakanPage extends StatefulWidget {
  @override
  _TambahTempatMakanPageState createState() => _TambahTempatMakanPageState();
}

class _TambahTempatMakanPageState extends State<TambahTempatMakanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController gambarController = TextEditingController();

  TimeOfDay? jamBuka;
  TimeOfDay? jamTutup;

  String? selectedDesaId;
  List<DropdownMenuItem<String>> desaItems = [];

  final TempatMakanService tempatMakanService = TempatMakanService();

  Future<void> _selectJamBuka(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        jamBuka = picked;
      });
    }
  }

  Future<void> _selectJamTutup(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        jamTutup = picked;
      });
    }
  }

  void tambahTempatMakan() async {
    if (jamBuka == null || jamTutup == null) {
      _showErrorDialog("Jam buka dan jam tutup harus dipilih.");
      return;
    }

    if (selectedDesaId == null) {
      _showErrorDialog("Desa harus dipilih.");
      return;
    }

    try {
      await tempatMakanService.tambahTempatMakan(
        nama: namaController.text,
        alamat: alamatController.text,
        jamBuka: jamBuka!,
        jamTutup: jamTutup!,
        kontak: kontakController.text,
        gambar: gambarController.text,
        desaId: selectedDesaId!,
      );

      setState(() {
        namaController.clear();
        alamatController.clear();
        kontakController.clear();
        gambarController.clear();
        jamBuka = null;
        jamTutup = null;
        selectedDesaId = null;
      });

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text('Tempat Makan berhasil ditambahkan!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewTempatMakanPage(),
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
        title: Text("Tambah Data Tempat Makan"),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 8,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Tambah Data Tempat Makan',
                      style: TextStyle(
                        color: Color(0xFF334d2b),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: namaController,
                    label: 'Nama Tempat Makan',
                    icon: Icons.restaurant,
                  ),
                  _buildTextField(
                    controller: alamatController,
                    label: 'Alamat',
                    icon: Icons.location_on,
                  ),
                  _buildTimeField(
                    label: 'Jam Buka',
                    time: jamBuka,
                    onPressed: () => _selectJamBuka(context),
                    icon: Icons.access_time,
                  ),
                  _buildTimeField(
                    label: 'Jam Tutup',
                    time: jamTutup,
                    onPressed: () => _selectJamTutup(context),
                    icon: Icons.access_time_outlined,
                  ),
                  _buildTextField(
                    controller: kontakController,
                    label: 'Kontak',
                    icon: Icons.phone,
                  ),
                  _buildTextField(
                    controller: gambarController,
                    label: 'URL Gambar',
                    icon: Icons.image,
                  ),
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
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width:
                          double.infinity, // Membuat tombol mengisi lebar penuh
                      child: ElevatedButton.icon(
                        onPressed: tambahTempatMakan,
                        label: Text('Tambah Tempat Makan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF334d2b),
                          foregroundColor: Color.fromARGB(255, 255, 255, 255),
                        ),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF334d2b)),
          prefixIcon: Icon(icon, color: Color(0xFF334d2b)),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildTimeField({
    required String label,
    required TimeOfDay? time,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextField(
        readOnly: true,
        onTap: onPressed,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Color(0xFF334d2b)),
          prefixIcon: Icon(icon, color: Color(0xFF334d2b)),
          suffixIcon: Icon(Icons.arrow_drop_down, color: Color(0xFF334d2b)),
          border: OutlineInputBorder(),
          hintText: time != null
              ? '${time.hour}:${time.minute.toString().padLeft(2, '0')}'
              : 'Pilih $label',
        ),
      ),
    );
  }
}
