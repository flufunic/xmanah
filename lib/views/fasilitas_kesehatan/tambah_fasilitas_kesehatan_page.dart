import 'package:flutter/material.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view_fasilitas_kesehatan_page.dart';

class TambahFasilitasKesehatanPage extends StatefulWidget {
  @override
  _TambahFasilitasKesehatanPageState createState() =>
      _TambahFasilitasKesehatanPageState();
}

class _TambahFasilitasKesehatanPageState
    extends State<TambahFasilitasKesehatanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();

  String selectedJenis = 'Puskesmas';
  List<String> jenisOptions = ['Puskesmas', 'Klinik', 'Rumah Sakit'];

  String? selectedDesaId;
  List<DropdownMenuItem<String>> desaItems = [];

  final FasilitasKesehatanService fasilitasKesehatanService =
      FasilitasKesehatanService();

  void tambahFasilitasKesehatan() async {
    if (namaController.text.isEmpty ||
        alamatController.text.isEmpty ||
        kontakController.text.isEmpty ||
        selectedDesaId == null ||
        _gambarController.text.isEmpty) {
      _showErrorDialog("Semua kolom harus diisi!");
      return;
    }

    try {
      await fasilitasKesehatanService.tambahFasilitasKesehatan(
        nama: namaController.text,
        jenis: selectedJenis,
        alamat: alamatController.text,
        kontak: kontakController.text,
        gambar: _gambarController.text,
        desaId: selectedDesaId!,
      );

      setState(() {
        namaController.clear();
        alamatController.clear();
        kontakController.clear();
        selectedJenis = 'Puskesmas';
        selectedDesaId = null;
        _gambarController.clear();
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
          content: Text('Fasilitas Kesehatan berhasil ditambahkan!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewFasilitasKesehatanPage(),
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
        title: Text("Tambah Data Fasilitas Kesehatan"),
        backgroundColor: Color(0xFF334d2b), // Warna AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tambah Data Fasilitas Kesehatan",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334d2b),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Fasilitas Kesehatan',
                      prefixIcon: Icon(Icons.business), // Ikon untuk input Nama
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: alamatController,
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      prefixIcon:
                          Icon(Icons.location_on), // Ikon untuk input Alamat
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedJenis,
                    items: jenisOptions
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedJenis = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Jenis Fasilitas',
                      prefixIcon:
                          Icon(Icons.local_hospital), // Ikon untuk input Jenis
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: kontakController,
                    decoration: InputDecoration(
                      labelText: 'Kontak',
                      prefixIcon: Icon(Icons.phone), // Ikon untuk input Kontak
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _gambarController,
                    decoration: InputDecoration(
                      labelText: 'URL Gambar',
                      prefixIcon: Icon(Icons.image), // Ikon untuk input Gambar
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.url,
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: selectedDesaId,
                    items: desaItems,
                    onChanged: (value) {
                      setState(() {
                        selectedDesaId = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Pilih Desa',
                      prefixIcon:
                          Icon(Icons.location_city), // Ikon untuk input Desa
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Membuat tombol submit menjadi full-width
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: tambahFasilitasKesehatan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF334d2b), // Warna tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                      child: Text(
                        'Tambah Fasilitas Kesehatan',
                        style: TextStyle(fontSize: 16, color: Colors.white),
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
}
