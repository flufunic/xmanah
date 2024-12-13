import 'package:flutter/material.dart';

class DetailTempatIbadah extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailTempatIbadah({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF334d2b), // AppBar color updated
        title: Text(
          'Detail Tempat Ibadah',
          style: TextStyle(color: Colors.white), // Text color updated
        ),
        elevation: 4.0, // Added elevation for shadow effect
      ),
      body: Container(
        color: Color(0xFF334d2b), // Background color of the page
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card untuk Gambar Tempat Ibadah
                Card(
                  color: Color(0xFFF1F8E9), // Light green background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Gambar Tempat Ibadah
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
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16), // Adding space between cards

                // Card untuk Data Tempat Ibadah (Alamat, Kategori, Jam Buka, Jam Tutup, Kontak)
                Card(
                  color: Color(0xFFF1F8E9), // Light green background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Tempat Ibadah
                        Text(
                          data['nama'] ?? 'Nama Tidak Tersedia',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334d2b), // Text color for name
                          ),
                        ),
                        SizedBox(height: 16),

                        // Alamat, Kategori, Jam Buka, Jam Tutup, Kontak dalam Card
                        _buildDetailRow(Icons.location_on, 'Alamat',
                            data['alamat'] ?? 'Tidak tersedia'),
                        _buildDetailRow(Icons.category, 'Kategori',
                            data['kategori'] ?? 'Tidak tersedia'),
                        _buildDetailRow(Icons.access_time, 'Jam Buka',
                            data['jamBuka'] ?? 'Tidak tersedia'),
                        _buildDetailRow(Icons.access_time, 'Jam Tutup',
                            data['jamTutup'] ?? 'Tidak tersedia'),
                        _buildDetailRow(Icons.phone, 'Kontak',
                            data['kontak'] ?? 'Tidak tersedia'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Function to create detail rows (Icon + Text)
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF334d2b), size: 24), // Icon for each row
          SizedBox(width: 10),
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
