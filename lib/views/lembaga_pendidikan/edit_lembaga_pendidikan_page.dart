import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';

class EditLembagaPendidikanPage extends StatefulWidget {
  final String lembagaId; // ID lembaga yang akan diedit

  EditLembagaPendidikanPage({required this.lembagaId});

  @override
  _EditLembagaPendidikanPageState createState() =>
      _EditLembagaPendidikanPageState();
}

class _EditLembagaPendidikanPageState extends State<EditLembagaPendidikanPage> {
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

  // Fetch lembaga data based on ID
  Future<void> _fetchLembagaData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('lembaga_pendidikan')
          .doc(widget.lembagaId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> lembagaData =
            snapshot.data() as Map<String, dynamic>;
        setState(() {
          namaController.text = lembagaData['nama'];
          alamatController.text = lembagaData['alamat'];
          kontakController.text = lembagaData['kontak'];
          ulasanController.text = lembagaData['ulasan'];
          selectedAkreditasi = lembagaData['akreditasi'];
          selectedTingkat = lembagaData['tingkat'];
          _selectedDesaId = lembagaData['desa_id'];
        });
      }
    } catch (e) {
      print("Gagal mengambil data lembaga: $e");
    }
  }

  // Function to update lembaga pendidikan
  void updateLembaga() async {
    try {
      if (_selectedDesaId != null) {
        await lembagaService.updateLembagaPendidikan(
          lembagaId: widget.lembagaId,
          nama: namaController.text,
          alamat: alamatController.text,
          akreditasi: selectedAkreditasi,
          tingkat: selectedTingkat,
          kontak: kontakController.text,
          ulasan: ulasanController.text,
          desaId: _selectedDesaId!, // Include desa_id
        );

        // Show success alert dialog
        _showSuccessDialog();
      } else {
        _showErrorDialog("Pilih desa terlebih dahulu!");
      }
    } catch (e) {
      // Handle error and show failure dialog
      _showErrorDialog(e.toString());
    }
  }

  // Function to show success dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Lembaga Pendidikan berhasil diperbarui!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Return to previous page
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

  @override
  void initState() {
    super.initState();
    _fetchDesaList(); // Fetch the desa list when the page is loaded
    _fetchLembagaData(); // Fetch the lembaga data based on ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Lembaga Pendidikan"),
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
              onPressed: updateLembaga,
              child: Text('Perbarui Lembaga Pendidikan'),
            ),
          ],
        ),
      ),
    );
  }
}
