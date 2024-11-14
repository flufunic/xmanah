import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart';

class EditFasilitasKesehatanPage extends StatefulWidget {
  final String fasilitasId; // ID fasilitas yang akan diedit

  EditFasilitasKesehatanPage(
      {required this.fasilitasId, required Map initialData});

  @override
  _EditFasilitasKesehatanPageState createState() =>
      _EditFasilitasKesehatanPageState();
}

class _EditFasilitasKesehatanPageState
    extends State<EditFasilitasKesehatanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController ulasanController = TextEditingController();

  String selectedJenis = 'Puskesmas'; // Default value for jenis
  String? _selectedDesaId; // To store selected desa_id
  List<DropdownMenuItem<String>> _desaItems = []; // List for desa dropdown

  // Options untuk dropdown
  List<String> jenisOptions = ['Puskesmas', 'Klinik', 'Rumah Sakit'];

  final FasilitasKesehatanService fasilitasKesehatanService =
      FasilitasKesehatanService();

  // Function to fetch fasilitas data based on ID
  Future<void> _fetchFasilitasData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('fasilitas_kesehatan')
          .doc(widget.fasilitasId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> fasilitasData =
            snapshot.data() as Map<String, dynamic>;
        setState(() {
          namaController.text = fasilitasData['nama'];
          alamatController.text = fasilitasData['alamat'];
          kontakController.text = fasilitasData['kontak'];
          ulasanController.text = fasilitasData['ulasan'];
          selectedJenis = fasilitasData['jenis'];
          _selectedDesaId = fasilitasData['desa_id'];
        });
      }
    } catch (e) {
      print("Gagal mengambil data fasilitas: $e");
    }
  }

  // Function to update fasilitas kesehatan
  void updateFasilitas() async {
    try {
      if (_selectedDesaId != null) {
        await fasilitasKesehatanService.updateFasilitasKesehatan(
          id: widget.fasilitasId,
          nama: namaController.text,
          jenis: selectedJenis,
          alamat: alamatController.text,
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
          content: Text('Fasilitas Kesehatan berhasil diperbarui!'),
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
          value: doc.id, // Ensure the value is the document ID
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
    _fetchFasilitasData(); // Fetch the fasilitas data based on ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Fasilitas Kesehatan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align left
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama Fasilitas'),
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
              items: jenisOptions.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Pilih Jenis Fasilitas Kesehatan'),
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
            Text('Desa', style: TextStyle(fontSize: 16)),
            _desaItems.isEmpty
                ? CircularProgressIndicator() // Loading spinner while items are being fetched
                : DropdownButton<String>(
                    value: _selectedDesaId,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDesaId = newValue;
                      });
                    },
                    items: _desaItems,
                    hint: Text('Pilih Desa'),
                    isExpanded: true, // Make dropdown full-width
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateFasilitas,
              child: Text('Perbarui Fasilitas Kesehatan'),
            ),
          ],
        ),
      ),
    );
  }
}
