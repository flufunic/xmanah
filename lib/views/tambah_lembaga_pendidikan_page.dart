import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';

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
  final TextEditingController ulasanController = TextEditingController();

  String selectedAkreditasi = 'A'; // Default value
  String selectedTingkat = 'SD'; // Default value
  String? _selectedDesaId; // To store selected desa_id
  List<DropdownMenuItem<String>> _desaItems = []; // List for desa dropdown

  // Options untuk dropdown
  List<String> akreditasiOptions = ['Unggul', 'A', 'B', 'C'];
  List<String> tingkatOptions = ['SD', 'SMP', 'SMA/K', 'Universitas'];

  final LembagaPendidikanService lembagaService = LembagaPendidikanService();

  // Fungsi untuk menambahkan lembaga pendidikan
  void tambahLembaga() async {
    try {
      if (_selectedDesaId != null) {
        await lembagaService.tambahLembagaPendidikan(
          nama: namaController.text,
          alamat: alamatController.text,
          akreditasi: selectedAkreditasi,
          tingkat: selectedTingkat,
          kontak: kontakController.text,
          ulasan: ulasanController.text,
          desaId: _selectedDesaId!, // Include desa_id
        );

        // Reset form setelah berhasil
        setState(() {
          namaController.clear();
          alamatController.clear();
          kontakController.clear();
          ulasanController.clear();
          selectedAkreditasi = 'A';
          selectedTingkat = 'SD';
          _selectedDesaId = null; // Clear selected desa
        });

        // Show success alert dialog after the data is added and form is cleared
        _showSuccessDialog();
      } else {
        _showErrorDialog("Pilih desa terlebih dahulu!");
      }
    } catch (e) {
      // Handle error and show failure dialog
      _showErrorDialog(e.toString());
    }
  }

  // Function to fetch desa list from Firestore
  Future<void> _fetchDesaList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('desa').get();
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem(
          value: doc.id,
          child: Text(doc['nama']), // Display desa name in dropdown
        );
      }).toList();
      setState(() {
        _desaItems = items;
      });
    } catch (e) {
      print("Gagal mengambil data desa: $e");
    }
  }

  // Function to show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Lembaga Pendidikan berhasil ditambahkan!'),
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
  void initState() {
    super.initState();
    _fetchDesaList(); // Fetch the desa list when the page is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Lembaga Pendidikan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align left
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama Lembaga'),
            ),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 10),
            Text('Akreditasi', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: selectedAkreditasi,
              onChanged: (String? newValue) {
                setState(() {
                  selectedAkreditasi = newValue!;
                });
              },
              items: akreditasiOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Pilih Akreditasi'),
              isExpanded: true, // Make dropdown full-width
            ),
            SizedBox(height: 10),
            Text('Tingkat', style: TextStyle(fontSize: 16)),
            DropdownButton<String>(
              value: selectedTingkat,
              onChanged: (String? newValue) {
                setState(() {
                  selectedTingkat = newValue!;
                });
              },
              items:
                  tingkatOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Pilih Tingkat'),
              isExpanded: true, // Make dropdown full-width
            ),
            SizedBox(height: 10),
            TextField(
              controller: kontakController,
              decoration: InputDecoration(labelText: 'Kontak'),
            ),
            TextField(
              controller: ulasanController,
              decoration: InputDecoration(labelText: 'Ulasan'),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedDesaId,
              items: _desaItems,
              onChanged: (value) {
                setState(() {
                  _selectedDesaId = value;
                });
              },
              decoration: InputDecoration(labelText: 'Desa'),
              validator: (value) => value == null ? 'Pilih desa' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: tambahLembaga,
              child: Text('Tambah Lembaga Pendidikan'),
            ),
          ],
        ),
      ),
    );
  }
}
