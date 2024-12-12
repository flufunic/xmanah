import 'package:flutter/material.dart';
import 'package:xmanah/controller/desa.dart';
class DesaDetail extends StatelessWidget {
  final Map<String, dynamic> desaData;

  const DesaDetail({Key? key, required this.desaData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(desaData['nama']),
        backgroundColor: Color(0xFF334d2b),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Image.network(
              desaData['gambar'] ?? 'https://via.placeholder.com/400x250',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            // Desa Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Desa
                  Text(
                    desaData['nama'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),

                  // Detailed Information
                  _buildDetailRow(
                    icon: Icons.location_on,
                    label: 'Alamat',
                    value: desaData['alamat'] ?? 'Tidak tersedia',
                  ),
                  _buildDetailRow(
                    icon: Icons.contact_mail,
                    label: 'Kode Pos',
                    value: desaData['kode_pos'] ?? 'Tidak tersedia',
                  ),
                  _buildDetailRow(
                    icon: Icons.phone,
                    label: 'Kontak',
                    value: desaData['kontak'] ?? 'Tidak tersedia',
                  ),

                  // Optional: Additional Description
                  if (desaData['deskripsi'] != null) ...[
                    SizedBox(height: 16),
                    Text(
                      'Tentang ${desaData['nama']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      desaData['deskripsi'],
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
    Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Color(0xFF334d2b), size: 24),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}