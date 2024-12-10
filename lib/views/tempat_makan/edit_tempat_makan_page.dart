import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTempatMakanPage extends StatefulWidget {
  final String tempatMakanId;
  final Map<String, dynamic> initialData;
  final String desaId; // Add desaId to this page

  EditTempatMakanPage({
    required this.tempatMakanId,
    required this.initialData,
    required this.desaId, // Pass desaId
  });

  @override
  _EditTempatMakanPageState createState() => _EditTempatMakanPageState();
}

class _EditTempatMakanPageState extends State<EditTempatMakanPage> {
  late TextEditingController namaController;
  late TextEditingController alamatController;
  late TextEditingController kontakController;
  late TextEditingController jamBukaController;
  late TextEditingController jamTutupController;
  late TextEditingController gambarController;

  String? selectedDesaId; // Selected desaId for dropdown
  List<DropdownMenuItem<String>> desaItems =
      []; // List of desa items for dropdown

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.initialData['nama']);
    alamatController =
        TextEditingController(text: widget.initialData['alamat']);
    kontakController =
        TextEditingController(text: widget.initialData['kontak']);
    jamBukaController =
        TextEditingController(text: widget.initialData['jamBuka']);
    jamTutupController =
        TextEditingController(text: widget.initialData['jamTutup']);
    gambarController =
        TextEditingController(text: widget.initialData['gambar']);
    selectedDesaId = widget.desaId; // Set initial selected desaId
    _fetchDesaList(); // Fetch desa list from Firestore
  }

  // Function to fetch desa list from Firestore
  Future<void> _fetchDesaList() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('desa').get();
      List<DropdownMenuItem<String>> items = snapshot.docs.map((doc) {
        return DropdownMenuItem<String>(
          value: doc.id,
          child: Text(doc['nama']), // Display desa name in dropdown
        );
      }).toList();
      setState(() {
        desaItems = items;
      });
    } catch (e) {
      print("Error fetching desa list: $e");
    }
  }

  // Update function with selected desaId
  Future<void> _updateTempatMakan() async {
    if (selectedDesaId == null) {
      _showErrorDialog("Desa harus dipilih.");
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('tempat_makan')
          .doc(widget.tempatMakanId)
          .update({
        'nama': namaController.text,
        'alamat': alamatController.text,
        'kontak': kontakController.text,
        'jamBuka': jamBukaController.text,
        'jamTutup': jamTutupController.text,
        'gambar': gambarController.text,
        'desa_id': selectedDesaId, // Include selected desa_id in the update
      });
      Navigator.pop(context); // Close after successful update
    } catch (e) {
      print("Error updating tempat makan: $e");
      _showErrorDialog("Gagal memperbarui tempat makan.");
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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
      appBar: AppBar(title: Text('Edit Data Tempat Makan')),
      backgroundColor: Color(0xFF334d2b), // Set background color of the page
      body: SingleChildScrollView(
        // Add scrolling capability to avoid overflow
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            // Add card around the form for neatness
            color: Colors.white, // Set card color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add title inside the card
                  Text(
                    'Edit Data Tempat Makan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334d2b),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: namaController,
                    label: 'Nama Tempat Makan',
                    icon: Icons.restaurant,
                  ),
                  _buildTextField(
                    controller: alamatController,
                    label: 'Alamat',
                    icon: Icons.location_on,
                  ),
                  _buildTextField(
                    controller: kontakController,
                    label: 'Kontak',
                    icon: Icons.phone,
                  ),
                  _buildTimeField(
                    controller: jamBukaController,
                    label: 'Jam Buka',
                    icon: Icons.access_time,
                  ),
                  _buildTimeField(
                    controller: jamTutupController,
                    label: 'Jam Tutup',
                    icon: Icons.access_time_rounded,
                  ),
                  _buildTextField(
                    controller: gambarController,
                    label: 'Gambar',
                    icon: Icons.image,
                  ),
                  // Dropdown for desa_id with border styling
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: selectedDesaId,
                    items: desaItems,
                    onChanged: (value) {
                      setState(() {
                        selectedDesaId = value;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.map, color: Color(0xFF334d2b)),
                      border: OutlineInputBorder(),
                    ),
                    hint: Text(
                      'Pilih Desa',
                      style: TextStyle(fontSize: 16, color: Color(0xFF334d2b)),
                    ),
                    isExpanded: true,
                  ),
                  SizedBox(height: 20),
                  // Full-width button 'Simpan Perubahan'
                  SizedBox(
                    width: double.infinity, // Ensures the button is full-width
                    child: ElevatedButton(
                      onPressed: _updateTempatMakan,
                      child: Text('Update Tempat Makan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF334d2b),
                        foregroundColor:
                            Color.fromARGB(255, 255, 255, 255), // Button color
                        padding: EdgeInsets.symmetric(vertical: 16),
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // White text
                        ),
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

  // Reusable function for text fields with icons
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF334d2b)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xFF334d2b),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable function for time input fields
  Widget _buildTimeField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.datetime,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Color(0xFF334d2b)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: Color(0xFF334d2b),
            ),
          ),
        ),
        onTap: () async {
          FocusScope.of(context).requestFocus(FocusNode());
          TimeOfDay? pickedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (pickedTime != null) {
            setState(() {
              controller.text = pickedTime.format(context);
            });
          }
        },
      ),
    );
  }
}
