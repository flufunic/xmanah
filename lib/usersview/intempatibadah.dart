import 'package:flutter/material.dart';
import 'package:xmanah/controller/tempat_ibadah.dart';

class DetailTempatIbadah extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailTempatIbadah({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF334d2b), // AppBar color updated
        title: Text(
          'Detail Tempat Ibadah',
          style: TextStyle(color: Colors.white), // Text color updated
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
                        Icons.place,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
              SizedBox(height: 16),

              // Title with styling
              Text(
                data['nama'] ?? 'Nama Tidak Tersedia',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334d2b), // Updated color
                ),
              ),
              SizedBox(height: 12),

              // Detail Rows with Card styling for each row
              _buildDetailCard('Alamat', data['alamat'] ?? 'Tidak tersedia'),
              _buildDetailCard('Jenis', data['jenis'] ?? 'Tidak tersedia'),
              _buildDetailCard('Jam Buka', data['jamBuka'] ?? 'Tidak tersedia'),
              _buildDetailCard('Jam Tutup', data['jamTutup'] ?? 'Tidak tersedia'),
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
                  color: Color(0xFF334d2b), // Label color updated
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
