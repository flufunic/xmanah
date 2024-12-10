import 'package:flutter/material.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';


class DetailLembagaPendidikan extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailLembagaPendidikan({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF334d2b), // Updated AppBar color
        title: Text(
          'Detail Lembaga Pendidikan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white, // Adjusted text color to match the new AppBar color
          ),
        ),
        elevation: 4.0,  // Added elevation for shadow effect
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with network or placeholder
              data['gambar'] != null && data['gambar'].isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        data['gambar'],
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.school,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
              SizedBox(height: 16),

              // Title with updated color
              Text(
                data['nama'] ?? 'Nama Tidak Tersedia',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334d2b), // Updated text color
                ),
              ),
              SizedBox(height: 12),

              // Detail Rows with Card styling for each row
              _buildDetailCard('Alamat', data['alamat'] ?? 'Tidak tersedia'),
              _buildDetailCard('Tingkat', data['tingkat'] ?? 'Tidak tersedia'),
              _buildDetailCard('Akreditasi', data['akreditasi'] ?? 'Tidak tersedia'),
              _buildDetailCard('Kontak', data['kontak'] ?? 'Tidak tersedia'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailCard(String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label + ':',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF334d2b), // Updated text color
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
