import 'package:flutter/material.dart';
import 'package:xmanah/controller/kost.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';
import 'package:xmanah/controller/tempat_makan.dart';
import 'package:xmanah/usersview/inkost.dart';
import 'package:xmanah/usersview/intempatmakan.dart';
import 'package:xmanah/usersview/inlembaga.dart';
import 'package:xmanah/usersview/kostuser.dart';
import 'package:xmanah/usersview/tempatmakanuser.dart';
import 'package:xmanah/usersview/fasilitasuser.dart';
import 'package:xmanah/usersview/desa.dart';
import 'package:xmanah/controller/desa.dart';
import 'widgets/banner_card.dart';

class HomePage extends StatelessWidget {
  final KostService kostService = KostService();
  final TempatMakanService tempatMakanService = TempatMakanService();
  final LembagaPendidikanService lembagaPendidikanService =
      LembagaPendidikanService();
  final DesaService desaService = DesaService();

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          children: [
                            TextSpan(
                              text: 'Selamat datang ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                    SizedBox(width: 16),
                    Image.asset(
                      'assets/images/xmanah.png',
                      height: 180,
                      width: 180,
                    ),
                  ],
                ),
              ),

              // Desa Menu
              _buildSectionHeader(context, 'Desa di Kalimanah',
                  onPressed: () {}),
              _buildDesaMenu(context),
              SizedBox(height: 20),

              // Section 1: Banner for Kost
              _buildSectionHeader(context, 'Kost Populer', onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => KostUser()));
              }),
              _buildFutureBannerList(
                future: kostService.getKostList(),
                placeholderText: 'Tidak ada data kost.',
                type: 'kost',
              ),
              SizedBox(height: 20),

              // Section 2: Banner for Tempat Makan Populer
              _buildSectionHeader(context, 'Tempat Makan Populer',
                  onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TempatMakanUser()));
              }),
              _buildFutureBannerList(
                future: tempatMakanService.getTempatMakanList(),
                placeholderText: 'Tidak ada data tempat makan.',
                type: 'tempat_makan',
              ),
              SizedBox(height: 20),

              // Section 3: Lembaga Pendidikan
              _buildSectionHeader(context, 'Lembaga Pendidikan', onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FasilitasUser()));
              }),
              _buildFutureBannerList(
                future: lembagaPendidikanService.getLembagaPendidikanList(),
                placeholderText: 'Tidak ada data lembaga pendidikan.',
                type: 'lembaga_pendidikan',
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build Desa Menu with Icon adjusted to the device width
  Widget _buildDesaMenu(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: desaService.getDesaList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Tidak ada data desa.'));
        } else {
          List<Map<String, dynamic>> desaList = snapshot.data!;
          double itemWidth = MediaQuery.of(context).size.width /
              5; // Calculate width for 5 items
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: desaList.map((desa) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    width:
                        itemWidth, // Adjust width of each item based on the screen size
                    child: _buildDesaMenuItem(
                      context: context,
                      label: desa['nama'],
                      desaData: desa,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }
      },
    );
  }

  // Build Individual Desa Menu Item with Icon
// Build Individual Desa Menu Item with Icon
  Widget _buildDesaMenuItem({
    required BuildContext context,
    required String label,
    required Map<String, dynamic> desaData,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DesaDetail(desaData: desaData),
          ),
        );
      },
      child: Column(
        children: [
          Icon(
            Icons.location_city,
            color: Colors.green, // Set the icon color to green
            size: 40, // Adjust the icon size
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.black, // Optional: Adjust text color
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Section Header Widget
  Widget _buildSectionHeader(BuildContext context, String title,
      {required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
    required String type,
  }) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(placeholderText));
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
                  child: GestureDetector(
                    onTap: () {
                      switch (type) {
                        case 'kost':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => KostDetail(
                                kostId: item['id'],
                                imageUrl: item['gambar'] ?? '',
                                name: item['nama'],
                                address: item['alamat'] ?? '',
                                kontak: item['kontak'] ?? '',
                                harga: item['harga'] ?? 0,
                                fasilitas: item['fasilitas'] ?? '',
                              ),
                            ),
                          );
                          break;
                        case 'tempat_makan':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TempatMakanDetail(
                                makanId: item['id'],
                                imageUrl: item['gambar'] ?? '',
                                name: item['nama'],
                                address: item['alamat'] ?? '',
                                openingHours: item['jam_operasional'] ?? '',
                              ),
                            ),
                          );
                          break;
                        case 'lembaga_pendidikan':
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailLembagaPendidikan(
                                data: item,
                              ),
                            ),
                          );
                          break;
                      }
                    },
                    child: BannerCard(
                      title: item['nama'],
                      imageUrl:
                          item['gambar'] ?? 'https://via.placeholder.com/200',
                    ),
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
