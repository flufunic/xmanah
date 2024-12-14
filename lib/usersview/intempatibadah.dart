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
        elevation: 6.0, // Added elevation for shadow effect
      ),
      body: Container(
        color: Color(0xFF334d2b), // Background color of the page
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Card for Image
                Card(
                  color: Color(0xFFF1F8E9), // Light green background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Image of Tempat Ibadah
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
                SizedBox(height: 20), // Adding space between cards

                // Card for Data (Address, Category, Opening hours, Contact)
                Card(
                  color: Color(0xFFF1F8E9), // Light green background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Tempat Ibadah
                        Text(
                          data['nama'] ?? 'Nama Tidak Tersedia',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334d2b), // Text color for name
                          ),
                        ),
                        SizedBox(height: 12),

                        // Alamat, Kategori, Jam Buka, Jam Tutup, Kontak in Detail Rows
                        _buildDetailRow(
                          Icons.location_on,
                          'Alamat',
                          data['alamat'] ?? 'Tidak tersedia',
                        ),
                        _buildDetailRow(
                          Icons.category,
                          'Kategori',
                          data['kategori'] ?? 'Tidak tersedia',
                        ),
                        _buildDetailRow(
                          Icons.access_time,
                          'Jam Buka',
                          data['jamBuka'] ?? 'Tidak tersedia',
                        ),
                        _buildDetailRow(
                          Icons.access_time,
                          'Jam Tutup',
                          data['jamTutup'] ?? 'Tidak tersedia',
                        ),
                        _buildDetailRow(
                          Icons.phone,
                          'Kontak',
                          data['kontak'] ?? 'Tidak tersedia',
                        ),
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
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF334d2b), size: 28), // Icon size adjusted
          SizedBox(width: 16), // Increased space between icon and text
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 18, // Increased font size for better readability
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
