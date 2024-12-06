import 'package:flutter/material.dart';
import 'package:xmanah/controller/kost.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';
import 'package:xmanah/controller/tempat_makan.dart';
import 'widgets/banner_card.dart';

class HomePage extends StatelessWidget {
  final KostService kostService = KostService();
  final TempatMakanService tempatMakanService = TempatMakanService();
  final LembagaPendidikanService lembagaPendidikanService =
      LembagaPendidikanService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center secara horizontal
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // Center secara vertikal
                  children: [
                    // Left side - Text
                    Expanded(
                      flex: 2,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          children: [
                            // "Selamat datang" - Bold
                            TextSpan(
                              text: 'Selamat datang ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // "di XMANAH," - Regular, warna ungu
                            TextSpan(
                              text: 'di XMANAH, ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ' di sini kamu bisa cari informasi apa saja seputar kecamatan Kalimanah.',
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                    // Right side - Logo
                    SizedBox(
                      width: 16,
                    ), // Add spacing between the text and the logo
                    Image.asset(
                      'assets/images/xmanah.png', // Your logo path here
                      height: 180, // Increase the logo size
                      width: 180,
                    ),
                  ],
                ),
              ),

              // Compact Grid Menu with smaller icon and text size
              Wrap(
                alignment: WrapAlignment.spaceEvenly,
                spacing: 20.0,
                runSpacing: 20.0,
                children: [
                  _buildMenuItem(
                    icon: Icons.apartment,
                    label: 'Kost',
                    color: const Color(0xFF334d2b),
                    iconSize: 24.0, // Ukuran ikon lebih kecil
                    labelSize: 12.0, // Ukuran teks lebih kecil
                    iconPadding: 10.0,
                    onPressed: () {
                      // Add navigation or functionality here
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.restaurant,
                    label: 'Tempat Makan',
                    color: const Color(0xFF334d2b),
                    iconSize: 24.0,
                    labelSize: 12.0,
                    iconPadding: 10.0,
                    onPressed: () {
                      // Add navigation or functionality here
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.mosque,
                    label: 'Tempat Ibadah',
                    color: const Color(0xFF334d2b),
                    iconSize: 24.0,
                    labelSize: 12.0,
                    iconPadding: 10.0,
                    onPressed: () {
                      // Add navigation or functionality here
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.local_hospital,
                    label: 'Fasilitas Kesehatan',
                    color: const Color(0xFF334d2b),
                    iconSize: 24.0,
                    labelSize: 12.0,
                    iconPadding: 10.0,
                    onPressed: () {
                      // Add navigation or functionality here
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.school,
                    label: 'Lembaga Pendidikan',
                    color: const Color(0xFF334d2b),
                    iconSize: 24.0,
                    labelSize: 12.0,
                    iconPadding: 10.0,
                    onPressed: () {
                      // Add navigation or functionality here
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Section 1: Banner for Kost
              _buildSectionHeader(context, 'Kost Populer', onPressed: () {
                // Add "Lihat Selengkapnya" functionality for kost
              }),
              _buildFutureBannerList(
                future: kostService.getKostList(),
                placeholderText: 'Tidak ada data kost.',
              ),
              SizedBox(height: 20),

              // Section 2: Banner for Tempat Makan Populer
              _buildSectionHeader(context, 'Tempat Makan Populer',
                  onPressed: () {
                // Add "Lihat Selengkapnya" functionality for tempat makan
              }),
              _buildFutureBannerList(
                future: tempatMakanService.getTempatMakanList(),
                placeholderText: 'Tidak ada data tempat makan.',
              ),
              SizedBox(height: 20),

              // Section 3: Lembaga Pendidikan
              _buildSectionHeader(context, 'Lembaga Pendidikan', onPressed: () {
                // Add "Lihat Selengkapnya" functionality for lembaga pendidikan
              }),
              _buildFutureBannerList(
                future: lembagaPendidikanService.getLembagaPendidikanList(),
                placeholderText: 'Tidak ada data lembaga pendidikan.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required Color color,
    double iconSize = 24.0,
    double labelSize = 12.0,
    double iconPadding = 10.0,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50, // Mengurangi ukuran kotak
            height: 50, // Mengurangi tinggi kotak agar lebih kecil
            decoration: BoxDecoration(
              color: Colors.white, // Warna latar belakang putih tanpa gradasi
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: Offset(5, 5),
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10.0,
                  offset: Offset(-5, -5),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: color,
            ),
          ),
          SizedBox(height: 8.0), // Jarak antara ikon dan label
          Container(
            width: 55, // Menentukan lebar kontainer agar teks bisa dibungkus
            child: Text(
              label,
              style: TextStyle(
                fontSize: labelSize,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2, // Membatasi teks menjadi maksimal 2 baris
              overflow: TextOverflow
                  .ellipsis, // Teks yang terlalu panjang akan dipotong dengan '...'
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title,
      {required VoidCallback onPressed}) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 8.0), // Adds space below the button
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF334d2b),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
            child: Text('Lihat Selengkapnya', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildFutureBannerList({
    required Future<List<Map<String, dynamic>>> future,
    required String placeholderText,
  }) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(placeholderText,
                  style: TextStyle(color: Color(0xFF334d2b))));
        } else {
          List<Map<String, dynamic>> itemList = snapshot.data!;
          return Container(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemList.length > 5 ? 5 : itemList.length,
              itemBuilder: (context, index) {
                var item = itemList[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: BannerCard(
                    title: item['nama'],
                    imageUrl:
                        item['gambar'] ?? 'https://via.placeholder.com/200',
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
