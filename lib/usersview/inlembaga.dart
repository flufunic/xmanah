import 'package:flutter/material.dart';

class DetailLembagaPendidikan extends StatelessWidget {
  final Map<String, dynamic> data;

  const DetailLembagaPendidikan({Key? key, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF334d2b), // Set background color
      appBar: AppBar(
        backgroundColor: Color(0xFF334d2b),
        title: Text(
          'Detail Lembaga Pendidikan',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card untuk Gambar Lembaga Pendidikan
              Card(
                color: Color(0xFFF1F8E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Gambar Lembaga Pendidikan
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16), // Adding space between cards

              // Card untuk Data Lembaga Pendidikan (Nama, Alamat, Tingkat, Akreditasi, Kontak)
              Card(
                color: Color(0xFFF1F8E9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Lembaga Pendidikan
                      Text(
                        data['nama'] ?? 'Nama Tidak Tersedia',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334d2b), // Text color for name
                        ),
                      ),
                      SizedBox(height: 16),

                      // Alamat, Tingkat, Akreditasi, Kontak dalam Card
                      _buildDetailRow(Icons.location_on, 'Alamat',
                          data['alamat'] ?? 'Tidak tersedia'),
                      _buildDetailRow(Icons.school, 'Tingkat',
                          data['tingkat'] ?? 'Tidak tersedia'),
                      _buildDetailRow(Icons.grade, 'Akreditasi',
                          data['akreditasi'] ?? 'Tidak tersedia'),
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
