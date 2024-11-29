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

  String selectedJenis = 'Puskesmas'; // Default value untuk jenis
  List<String> jenisOptions = ['Puskesmas', 'Klinik', 'Rumah Sakit'];

  String? selectedDesaId; // ID Desa yang dipilih
  List<DropdownMenuItem<String>> desaItems = []; // Dropdown desa

  final FasilitasKesehatanService fasilitasKesehatanService =
      FasilitasKesehatanService();

  // Fungsi untuk menambahkan fasilitas kesehatan
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
        gambar: _gambarController.text, // Gunakan URL gambar dari input
        desaId: selectedDesaId!,
      );

      // Reset form setelah berhasil
      setState(() {
        namaController.clear();
        alamatController.clear();
        kontakController.clear();
        selectedJenis = 'Puskesmas'; // Reset jenis ke default
        selectedDesaId = null; // Reset ID Desa
        _gambarController.clear(); // Reset input gambar
      });

      _showSuccessDialog();
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  // Function to show success dialog
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
        desaItems = items;
      });
    } catch (e) {
      print("Gagal mengambil data desa: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDesaList(); // Load the desa list when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Fasilitas Kesehatan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align left
            children: [
              TextField(
                controller: namaController,
                decoration:
                    InputDecoration(labelText: 'Nama Fasilitas Kesehatan'),
              ),
              TextField(
                controller: alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
              ),
              SizedBox(height: 10),
              Text('Jenis Fasilitas', style: TextStyle(fontSize: 16)),
              DropdownButton<String>(
                value: selectedJenis,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedJenis = newValue!;
                  });
                },
                items:
                    jenisOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: Text('Pilih Jenis Fasilitas Kesehatan'),
                isExpanded: true,
              ),
              SizedBox(height: 10),
              TextField(
                controller: kontakController,
                decoration: InputDecoration(labelText: 'Kontak'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _gambarController,
                decoration: InputDecoration(labelText: 'URL Gambar'),
                keyboardType: TextInputType.url, // Allow URL input
              ),
              SizedBox(height: 10),
              Text('Pilih Desa', style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: selectedDesaId,
                items: desaItems,
                onChanged: (value) {
                  setState(() {
                    selectedDesaId = value;
                  });
                },
                decoration: InputDecoration(labelText: 'Desa'),
                isExpanded: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: tambahFasilitasKesehatan,
                child: Text('Tambah Fasilitas Kesehatan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
