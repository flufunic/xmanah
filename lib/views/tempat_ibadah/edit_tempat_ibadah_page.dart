import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTempatIbadahPage extends StatefulWidget {
  final String tempatIbadahId;

  EditTempatIbadahPage({required this.tempatIbadahId});

  @override
  _EditTempatIbadahPageState createState() => _EditTempatIbadahPageState();
}

class _EditTempatIbadahPageState extends State<EditTempatIbadahPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController namaController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController kontakController = TextEditingController();
  final TextEditingController ulasanController = TextEditingController();
  final TextEditingController jamBukaController = TextEditingController();
  final TextEditingController jamTutupController = TextEditingController();

  String selectedKategori = 'Masjid';
  String? selectedDesaId;
  List<DropdownMenuItem<String>> desaItems = [];

  List<String> kategoriOptions = [
    'Masjid',
    'Klenteng',
    'Vihara',
    'Gereja',
    'Pura',
  ];

  @override
  void initState() {
    super.initState();
    _fetchDesaList();
    _loadTempatIbadahData();
  }

  // Fetch desa list for dropdown
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

  // Load existing Tempat Ibadah data
  Future<void> _loadTempatIbadahData() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('tempat_ibadah')
          .doc(widget.tempatIbadahId)
          .get();

      if (docSnapshot.exists) {
        var data = docSnapshot.data() as Map<String, dynamic>;

        namaController.text = data['nama'];
        alamatController.text = data['alamat'];
        kontakController.text = data['kontak'];
        ulasanController.text = data['ulasan'];
        selectedKategori = data['kategori'];
        selectedDesaId = data['desa_id'];

        // Set time format for Jam Buka and Jam Tutup
        var jamBukaStr = data['jamBuka'].split(':');
        jamBukaController.text = '${jamBukaStr[0]}:${jamBukaStr[1]}';

        var jamTutupStr = data['jamTutup'].split(':');
        jamTutupController.text = '${jamTutupStr[0]}:${jamTutupStr[1]}';

        setState(() {});
      }
    } catch (e) {
      print("Gagal memuat data tempat ibadah: $e");
    }
  }

  // Save the edited Tempat Ibadah
  void updateTempatIbadah() async {
    if (_formKey.currentState!.validate() && selectedDesaId != null) {
      try {
        // Updating the existing document in Firestore using the tempatIbadahId passed to this page
        await FirebaseFirestore.instance
            .collection('tempat_ibadah')
            .doc(widget.tempatIbadahId)
            .update({
          'nama': namaController.text,
          'kategori': selectedKategori,
          'alamat': alamatController.text,
          'jamBuka': jamBukaController.text,
          'jamTutup': jamTutupController.text,
          'kontak': kontakController.text,
          'ulasan': ulasanController.text,
          'desa_id': selectedDesaId,
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Data tempat ibadah berhasil diperbarui'),
        ));

        Navigator.pop(context); // Go back to the previous page
      } catch (e) {
        print("Gagal memperbarui tempat ibadah: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Terjadi kesalahan saat memperbarui data'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Tempat Ibadah'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(labelText: 'Nama Tempat Ibadah'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama tempat ibadah harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Alamat harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: kontakController,
                decoration: InputDecoration(labelText: 'Kontak'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Kontak harus diisi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: ulasanController,
                decoration: InputDecoration(labelText: 'Ulasan'),
              ),
              DropdownButtonFormField<String>(
                value: selectedKategori,
                onChanged: (newValue) {
                  setState(() {
                    selectedKategori = newValue!;
                  });
                },
                items: kategoriOptions
                    .map((kategori) => DropdownMenuItem(
                          value: kategori,
                          child: Text(kategori),
                        ))
                    .toList(),
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
              DropdownButtonFormField<String>(
                value: selectedDesaId,
                onChanged: (newValue) {
                  setState(() {
                    selectedDesaId = newValue!;
                  });
                },
                items: desaItems,
                decoration: InputDecoration(labelText: 'Desa'),
              ),
              TextFormField(
                controller: jamBukaController,
                decoration: InputDecoration(
                  labelText: 'Jam Buka',
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () => _selectJam(context, 'jamBuka'),
                readOnly: true, // Make it read-only since it's a picker
              ),
              TextFormField(
                controller: jamTutupController,
                decoration: InputDecoration(
                  labelText: 'Jam Tutup',
                  suffixIcon: Icon(Icons.access_time),
                ),
                onTap: () => _selectJam(context, 'jamTutup'),
                readOnly: true, // Make it read-only since it's a picker
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: updateTempatIbadah,
                child: Text('Update Tempat Ibadah'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Time picker for Jam Buka and Jam Tutup
  Future<void> _selectJam(BuildContext context, String field) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: field == 'jamBuka'
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        if (field == 'jamBuka') {
          jamBukaController.text = picked.format(context);
        } else {
          jamTutupController.text = picked.format(context);
        }
      });
    }
  }
}
