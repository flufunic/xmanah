import 'package:flutter/material.dart';
import 'package:xmanah/controller/tempat_ibadah.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'view_tempat_ibadah_page.dart'; // Import ViewTempatIbadahPage

class TambahTempatIbadahPage extends StatefulWidget {
  @override
  _TambahTempatIbadahPageState createState() => _TambahTempatIbadahPageState();
}

class _TambahTempatIbadahPageState extends State<TambahTempatIbadahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk masing-masing field
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController ulasanController = TextEditingController();

  TimeOfDay? jamBuka; // Jam Buka menggunakan TimeOfDay
  TimeOfDay? jamTutup; // Jam Tutup menggunakan TimeOfDay

  String selectedKategori = 'Masjid'; // Default value untuk kategori
  String? selectedDesaId; // Desa ID yang dipilih
  List<DropdownMenuItem<String>> desaItems = []; // Dropdown desa

  List<String> kategoriOptions = [
    'Masjid',
    'Klenteng',
    'Vihara',
    'Gereja',
    'Pura'
  ]; // Opsi kategori

  final TempatIbadahService tempatIbadahService = TempatIbadahService();

  @override
  void initState() {
    super.initState();
    _fetchDesaList(); // Load the desa list when the page is initialized
  }

  // Fetch desa data from Firestore and populate dropdown items
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

  // Fungsi untuk menambahkan tempat ibadah
  void tambahTempatIbadah() async {
    if (_formKey.currentState!.validate() &&
        jamBuka != null &&
        jamTutup != null &&
        selectedDesaId != null) {
      try {
        await tempatIbadahService.tambahTempatIbadah(
          nama: namaController.text,
          kategori: selectedKategori,
          alamat: alamatController.text,
          jamBuka: jamBuka!,
          jamTutup: jamTutup!,
          kontak: kontakController.text,
          ulasan: ulasanController.text,
          desaId: selectedDesaId!, // Menambahkan desaId
        );

        // Reset form setelah berhasil
        setState(() {
          namaController.clear();
          alamatController.clear();
          kontakController.clear();
          ulasanController.clear();
          jamBuka = null;
          jamTutup = null;
          selectedKategori = 'Masjid'; // Reset kategori ke default
          selectedDesaId = null; // Reset desaId
        });

        // Tampilkan alert dialog setelah data berhasil ditambahkan
        _showSuccessDialog();
      } catch (e) {
        // Tampilkan error dialog jika terjadi kesalahan
        _showErrorDialog(e.toString());
      }
    }
  }

  // Function to show success dialog and navigate to ViewTempatIbadahPage
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sukses'),
          content: Text('Tempat Ibadah berhasil ditambahkan!'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ViewTempatIbadahPage(), // Navigate to View page
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
      appBar: AppBar(
        title: Text("Tambah Tempat Ibadah"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align left
            children: [
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Tempat Ibadah'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tempat ibadah harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Text('Kategori', style: TextStyle(fontSize: 16)),
              DropdownButtonFormField<String>(
                value: selectedKategori,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedKategori = newValue!;
                  });
                },
                items: kategoriOptions
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Pilih Kategori'),
                validator: (value) {
                  if (value == null) {
                    return 'Pilih kategori terlebih dahulu';
                  }
                  return null;
                },
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
              TextFormField(
                controller: kontakController,
                decoration: InputDecoration(labelText: 'Kontak'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kontak harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ulasanController,
                decoration: InputDecoration(labelText: 'Ulasan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ulasan harus diisi';
                  }
                  return null;
                },
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
                decoration: InputDecoration(labelText: 'Desa'),
                validator: (value) {
                  if (value == null) {
                    return 'Pilih desa terlebih dahulu';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: tambahTempatIbadah,
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
