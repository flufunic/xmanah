import 'package:flutter/material.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart';

class DetailFasilitasKesehatan extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailFasilitasKesehatan({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFF334d2b), // Set background color to Color(0xFF334d2b)
      appBar: AppBar(
        backgroundColor: Color(0xFF334d2b), // Keep AppBar color consistent
        title: Row(
          children: [
            Icon(Icons.local_hospital, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Detail Fasilitas Kesehatan',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        elevation: 8.0,
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
                      borderRadius: BorderRadius.circular(20),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.local_hospital,
                        size: 100,
                        color: Colors.white,
                      ),
                    ),
              SizedBox(height: 16),

              // Title with styling
              Text(
                data['nama'] ?? 'Nama Tidak Tersedia',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color:
                      Color.fromARGB(255, 255, 255, 255), // Text color updated
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.3),
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),

              // Detail Rows with Card styling for each row
              _buildDetailCard('Alamat', data['alamat'] ?? 'Tidak tersedia'),
              _buildDetailCard('Jenis', data['jenis'] ?? 'Tidak tersedia'),
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
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6.0,
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: Color(0xFFF1F8E9), // Soft light green background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              label == 'Alamat'
                  ? Icons.location_on
                  : (label == 'Kontak' ? Icons.phone : Icons.info),
              color: Color(0xFF334d2b),
              size: 24,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF334d2b),
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
