import 'package:flutter/material.dart';

class DesaDetail extends StatelessWidget {
  final Map<String, dynamic> desaData;

  const DesaDetail({Key? key, required this.desaData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          desaData['nama'],
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF334d2b),
        elevation: 6.0, // AppBar elevation fixed here
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFF334d2b),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image in a Card with elevated shadow and rounded corners
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8, // Slightly higher elevation for better shadow effect
                shadowColor: Colors.black45, // Soft shadow color
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    desaData['gambar'] ?? 'https://via.placeholder.com/400x250',
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 20), // Space between the image and details

              // Desa Details in a Stylish Card
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 6,
                shadowColor: Colors.black26,
                margin: EdgeInsets.symmetric(vertical: 10), // Margin for better spacing
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama Desa (Stylized)
                      Text(
                        desaData['nama'],
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334d2b),
                        ),
                      ),
                      SizedBox(height: 12),
                      Divider(
                        color: Color(0xFF334d2b),
                        thickness: 2,
                      ),
                      SizedBox(height: 16),

                      // Address, Postal Code, Contact Information
                      _buildDetailRow(
                        Icons.location_on,
                        'Alamat',
                        desaData['alamat'] ?? 'Tidak tersedia',
                      ),
                      _buildDetailRow(
                        Icons.location_pin,
                        'Kode Pos',
                        desaData['kode_pos'] ?? 'Tidak tersedia',
                      ),
                      _buildDetailRow(
                        Icons.phone,
                        'Kontak',
                        desaData['kontak'] ?? 'Tidak tersedia',
                      ),

                      // Optional: About the Village Section
                      if (desaData['deskripsi'] != null) ...[
                        SizedBox(height: 16),
                        Text(
                          'Tentang ${desaData['nama']}',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334d2b),
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
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  // Custom Widget to create detail rows (Icon + Label + Value)
  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: Color(0xFF334d2b),
            size: 30, // Increased icon size for better visibility
          ),
          SizedBox(width: 16), // Increased space between icon and text
          Expanded(
            child: Text(
              '$label: $value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF334d2b),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
