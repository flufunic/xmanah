import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xmanah/controller/kost.dart';
import 'package:xmanah/views/kost/view_kost_page.dart';

class EditKostPage extends StatefulWidget {
  final String kostId; // ID of the Kost to edit

  EditKostPage({required this.kostId});

  @override
  _EditKostPageState createState() => _EditKostPageState();
}

class _EditKostPageState extends State<EditKostPage> {
  final _formKey = GlobalKey<FormState>();

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
    _fetchKostData();
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
        _desaItems = items;
      });
    } catch (e) {
      print("Gagal mengambil data desa: $e");
    }
  }

  // Fetch existing kost data
  Future<void> _fetchKostData() async {
    try {
      DocumentSnapshot kostSnapshot = await FirebaseFirestore.instance
          .collection('kost')
          .doc(widget.kostId)
          .get();
      if (kostSnapshot.exists) {
        var data = kostSnapshot.data() as Map<String, dynamic>;
        _namaController.text = data['nama'];
        _alamatController.text = data['alamat'];
        _fasilitasController.text = data['fasilitas'];
        _kontakController.text = data['kontak'];
        _hargaController.text = data['harga'].toString();
        _ulasanController.text = data['ulasan'];
        _gambarController.text = data['gambar'];
        _selectedDesaId = data['desa_id'];
        setState(() {});
      }
    } catch (e) {
      print("Gagal mengambil data kost: $e");
    }
  }

  Future<void> _updateKost() async {
    if (_formKey.currentState!.validate() && _selectedDesaId != null) {
      await _kostService.updateKost(
        kostId: widget.kostId,
        nama: _namaController.text,
        alamat: _alamatController.text,
        fasilitas: _fasilitasController.text,
        kontak: _kontakController.text,
        harga: int.parse(_hargaController.text),
        ulasan: _ulasanController.text,
        gambar: _gambarController.text,
        desaId: _selectedDesaId!,
      );

      // Show success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Berhasil!'),
            content: Text('Data kos berhasil diperbarui.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Navigate to the ViewKostPage after successful update
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewKostPage(),
                    ),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
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
        title: Text('Edit Data Kos'),
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
                  onPressed: _updateKost,
                  child: Text('Perbarui Data Kos'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
