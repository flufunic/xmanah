import 'package:flutter/material.dart';

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
              // Card untuk Gambar Fasilitas Kesehatan
              Card(
                color: Color(0xFFF1F8E9), // Light green background for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: data['gambar'] != null && data['gambar'].isNotEmpty
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
                            Icons.local_hospital,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 16), // Adding space between cards

              // Card untuk Data Fasilitas Kesehatan (Alamat, Jenis, Kontak)
              Card(
                color: Color(0xFFF1F8E9), // Light green background for the card
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Fasilitas Kesehatan
                      Text(
                        data['nama'] ?? 'Nama Tidak Tersedia',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334d2b),
                          shadows: [
                            Shadow(
                              blurRadius: 5.0,
                              color: Colors.black.withOpacity(0.3),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      // Alamat, Jenis, Kontak dalam Card dengan ikon
                      _buildDetailRow(Icons.location_on, 'Alamat',
                          data['alamat'] ?? 'Tidak tersedia'),
                      _buildDetailRow(Icons.category, 'Jenis',
                          data['jenis'] ?? 'Tidak tersedia'),
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
          SizedBox(width: 16),
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
