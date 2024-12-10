import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart';

class EditFasilitasKesehatanPage extends StatefulWidget {
  final String fasilitasId; // ID fasilitas yang akan diedit

  EditFasilitasKesehatanPage(
      {required this.fasilitasId, required Map<String, dynamic> initialData});

  @override
  _EditFasilitasKesehatanPageState createState() =>
      _EditFasilitasKesehatanPageState();
}

class _EditFasilitasKesehatanPageState
    extends State<EditFasilitasKesehatanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController gambarController =
      TextEditingController(); // Controller untuk gambar

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
          gambarController.text = fasilitasData['gambar']; // Isi gambar
          selectedJenis = fasilitasData['jenis'];
          _selectedDesaId = fasilitasData['desa_id'];
        });
      }
    } catch (e) {
      print("Gagal mengambil data fasilitas: $e");
    }
  }

  // Function to fetch desa list from Firestore
  Future<void> _fetchDesaList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('desa').get();
      List<DropdownMenuItem<String>> items = [];
      snapshot.docs.forEach((doc) {
        items.add(DropdownMenuItem(
          value: doc.id,
          child: Text(doc['nama']),
        ));
      });

      setState(() {
        _desaItems = items;

        // Ensure _selectedDesaId is valid (it must exist in the dropdown items)
        if (_selectedDesaId != null &&
            !items.any((item) => item.value == _selectedDesaId)) {
          _selectedDesaId = null; // Reset if not found in the fetched list
        }
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
          gambar: gambarController.text, // Tambahkan gambar
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF334d2b),
      appBar: AppBar(
        title: Text("Edit Data Fasilitas Kesehatan"),
        backgroundColor: Color(0xFF334d2b), // AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align left
            children: [
              // Card yang mencakup semua inputan
              Card(
                elevation: 5, // Elevation for shadow effect
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "Edit Data Fasilitas Kesehatan",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334d2b),
                        ),
                      ),
                      // Nama Fasilitas
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF334d2b),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: namaController,
                          decoration: InputDecoration(
                            labelText: 'Nama Fasilitas',
                            prefixIcon: Icon(Icons
                                .local_hospital), // Icon untuk nama fasilitas
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16), // Spacing between fields
                      // Alamat
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF334d2b),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: alamatController,
                          decoration: InputDecoration(
                            labelText: 'Alamat',
                            prefixIcon:
                                Icon(Icons.location_on), // Icon untuk alamat
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Jenis Fasilitas dengan ikon
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Jenis Fasilitas',
                              style: TextStyle(fontSize: 16)),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF334d2b),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              value: selectedJenis,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedJenis = newValue!;
                                });
                              },
                              items: jenisOptions.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Icon(Icons.medical_services),
                                      SizedBox(width: 8),
                                      Text(value),
                                    ],
                                  ),
                                );
                              }).toList(),
                              hint: Text('Pilih Jenis Fasilitas Kesehatan'),
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Kontak
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF334d2b),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: kontakController,
                          decoration: InputDecoration(
                            labelText: 'Kontak',
                            prefixIcon: Icon(Icons.phone), // Icon untuk kontak
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // URL Gambar
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF334d2b),
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                          controller: gambarController,
                          decoration: InputDecoration(
                            labelText: 'URL Gambar',
                            prefixIcon: Icon(Icons.image), // Icon untuk gambar
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // Dropdown Desa dengan ikon di kiri
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Desa',
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF334d2b),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButton<String>(
                              icon: Icon(Icons.location_city),
                              value: _selectedDesaId,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedDesaId = newValue;
                                });
                              },

                              items: _desaItems,
                              hint: Text('Pilih Desa'),
                              isExpanded: true, // Icon Desa
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      // Tombol Update
                      ElevatedButton(
                        onPressed: updateFasilitas,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Color(0xFF334d2b), // Background color
                          minimumSize: Size(double.infinity, 50), // Full-width
                        ),
                        child: Text(
                          'Update Fasilitas Kesehatan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
