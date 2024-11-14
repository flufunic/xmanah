import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/kost.dart';

class TambahKostPage extends StatefulWidget {
  @override
  _TambahKostPageState createState() => _TambahKostPageState();
}

class _TambahKostPageState extends State<TambahKostPage> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk masing-masing field
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _fasilitasController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();
  final TextEditingController _ulasanController = TextEditingController();
  final TextEditingController _gambarController = TextEditingController();

  final KostService _kostService = KostService();

  String? _selectedDesaId;
  List<DropdownMenuItem<String>> _desaItems = [];

  @override
  void initState() {
    super.initState();
    _fetchDesaList();
  }

  // Fetch desa data from Firestore and populate dropdown items
  Future<void> _fetchDesaList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('desa').get();
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem(
          value: doc.id,
          child: Text(doc['nama']), // menampilkan nama desa dalam dropdown
        );
      }).toList();
      setState(() {
        _desaItems = items;
      });
    } catch (e) {
      print("Gagal mengambil data desa: $e");
    }
  }

  Future<void> _simpanKost() async {
    if (_formKey.currentState!.validate() && _selectedDesaId != null) {
      await _kostService.tambahKost(
        nama: _namaController.text,
        alamat: _alamatController.text,
        fasilitas: _fasilitasController.text,
        kontak: _kontakController.text,
        harga: int.parse(_hargaController.text),
        ulasan: _ulasanController.text,
        gambar: _gambarController.text,
        desaId: _selectedDesaId!,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data kos berhasil ditambahkan!')),
      );

      // Bersihkan form setelah menyimpan
      _namaController.clear();
      _alamatController.clear();
      _fasilitasController.clear();
      _kontakController.clear();
      _hargaController.clear();
      _ulasanController.clear();
      _gambarController.clear();
      setState(() {
        _selectedDesaId = null;
      });
    } else if (_selectedDesaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pilih desa terlebih dahulu!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Data Kos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(labelText: 'Nama Kos'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama kos harus diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(labelText: 'Alamat'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Alamat harus diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _fasilitasController,
                  decoration: InputDecoration(labelText: 'Fasilitas'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Fasilitas harus diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _kontakController,
                  decoration: InputDecoration(labelText: 'Kontak'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kontak harus diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _hargaController,
                  decoration: InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Harga harus diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ulasanController,
                  decoration: InputDecoration(labelText: 'Ulasan'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ulasan harus diisi';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _gambarController,
                  decoration: InputDecoration(labelText: 'URL Gambar'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'URL Gambar harus diisi';
                    }
                    return null;
                  },
                ),
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
                  onPressed: _simpanKost,
                  child: Text('Simpan Data Kos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
