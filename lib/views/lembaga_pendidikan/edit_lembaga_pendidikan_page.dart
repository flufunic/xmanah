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
  final TextEditingController gambarController = TextEditingController();

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
          gambarController.text = lembagaData['gambar'];
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
          gambar: gambarController.text,
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
          title: Text('Sukses'),
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
        title: Text("Edit  Data Lembaga Pendidikan"),
      ),
      body: SingleChildScrollView(
        // Wrap the content with SingleChildScrollView
        child: Container(
          color: Color(0xFF334d2b), // Background color
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align left
                children: [
                  Text(
                    'Edit Data Lembaga Pendidikan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334d2b),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Nama Lembaga TextField
                  TextField(
                    controller: namaController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lembaga',
                      prefixIcon: Icon(Icons.school, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(), // Add border here
                    ),
                  ),
                  SizedBox(height: 10),
                  // Alamat TextField
                  TextField(
                    controller: alamatController,
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      prefixIcon:
                          Icon(Icons.location_on, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(), // Add border here
                    ),
                  ),
                  SizedBox(height: 10),
                  // Kontak TextField
                  TextField(
                    controller: kontakController,
                    decoration: InputDecoration(
                      labelText: 'Kontak',
                      prefixIcon: Icon(Icons.phone, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(), // Add border here
                    ),
                  ),
                  SizedBox(height: 10),
                  // Gambar Link TextField
                  TextField(
                    controller: gambarController,
                    decoration: InputDecoration(
                      labelText: 'Link Gambar',
                      prefixIcon: Icon(Icons.image, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(), // Add border here
                    ),
                  ),
                  SizedBox(height: 10),
                  // Akreditasi Dropdown with border
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Akreditasi',
                      prefixIcon: Icon(Icons.star, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(), // Add border here
                    ),
                    child: DropdownButton<String>(
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
                      isExpanded: true, // Make dropdown full-width
                    ),
                  ),
                  SizedBox(height: 10),
                  // Tingkat Dropdown with border
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Tingkat',
                      prefixIcon: Icon(Icons.school, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(), // Add border here
                    ),
                    child: DropdownButton<String>(
                      value: selectedTingkat,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedTingkat = newValue!;
                        });
                      },
                      items: tingkatOptions
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      isExpanded: true, // Make dropdown full-width
                    ),
                  ),
                  SizedBox(height: 10),
                  // Desa Dropdown with border
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Desa',
                      prefixIcon:
                          Icon(Icons.location_city, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(), // Add border here
                    ),
                    child: DropdownButton<String>(
                      value: _selectedDesaId,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedDesaId = newValue;
                        });
                      },
                      items: _desaItems,
                      isExpanded: true, // Make dropdown full-width
                    ),
                  ),
                  SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: updateLembaga,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF334d2b), // Button color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Update Lembaga Pendidikan',
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
}
