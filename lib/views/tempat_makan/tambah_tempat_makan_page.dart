import 'package:flutter/material.dart';
import 'package:xmanah/controller/tempat_makan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view_tempat_makan_page.dart'; // Import the view page to navigate after success

class TambahTempatMakanPage extends StatefulWidget {
  @override
  _TambahTempatMakanPageState createState() => _TambahTempatMakanPageState();
}

class _TambahTempatMakanPageState extends State<TambahTempatMakanPage> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController ulasanController = TextEditingController();

  TimeOfDay? jamBuka; // Jam Buka menggunakan TimeOfDay
  TimeOfDay? jamTutup; // Jam Tutup menggunakan TimeOfDay

  String? selectedDesaId; // ID Desa yang dipilih
  List<DropdownMenuItem<String>> desaItems = []; // Dropdown desa

  final TempatMakanService tempatMakanService = TempatMakanService();

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

  // Fungsi untuk menambahkan tempat makan
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
        ulasan: ulasanController.text,
        desaId: selectedDesaId!,
      );

      // Reset form setelah berhasil
      setState(() {
        namaController.clear();
        alamatController.clear();
        kontakController.clear();
        ulasanController.clear();
        jamBuka = null;
        jamTutup = null;
        selectedDesaId = null; // Reset ID Desa
      });

      // Tampilkan alert dialog setelah data berhasil ditambahkan
      _showSuccessDialog();
    } catch (e) {
      // Tampilkan error dialog jika terjadi kesalahan
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
          content: Text('Tempat Makan berhasil ditambahkan!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the success dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewTempatMakanPage(), // Navigate to ViewTempatMakanPage
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
                Navigator.of(context).pop(); // Close the error dialog
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

  @override
  void initState() {
    super.initState();
    _fetchDesaList(); // Load the desa list when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Tempat Makan"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align left
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(labelText: 'Nama Tempat Makan'),
            ),
            TextField(
              controller: alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 10),
            Text('Jam Buka', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectJamBuka(context),
                  child: Text(jamBuka != null
                      ? '${jamBuka!.hour}:${jamBuka!.minute}'
                      : 'Pilih Jam Buka'),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text('Jam Tutup', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectJamTutup(context),
                  child: Text(jamTutup != null
                      ? '${jamTutup!.hour}:${jamTutup!.minute}'
                      : 'Pilih Jam Tutup'),
                ),
              ],
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
              isExpanded: true, // Full-width dropdown
              validator: (value) {
                if (value == null) {
                  return 'Pilih desa terlebih dahulu';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: tambahTempatMakan,
              child: Text('Tambah Tempat Makan'),
            ),
          ],
        ),
      ),
    );
  }
}
