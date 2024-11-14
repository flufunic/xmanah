import 'package:flutter/material.dart';
import 'package:xmanah/controller/kost.dart';
import 'widgets/banner_card.dart';

class HomePage extends StatelessWidget {
  final KostService kostService = KostService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Banner
              Text(
                'Kost Populer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              // Menggunakan FutureBuilder untuk menampilkan banner
              FutureBuilder<List<Map<String, dynamic>>>(
                future: kostService.getKostList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Tidak ada data kost.'));
                  } else {
                    List<Map<String, dynamic>> kostList = snapshot.data!;
                    return Container(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: kostList.length > 5
                            ? 5
                            : kostList.length, // Tampilkan maksimal 5 banner
                        itemBuilder: (context, index) {
                          var kost = kostList[index];
                          return BannerCard(
                            title: kost['nama'], // Menampilkan nama kost
                            description:
                                kost['fasilitas'], // Menampilkan fasilitas
                            imageUrl: kost['gambar'] ??
                                'https://via.placeholder.com/200', // Menampilkan gambar kost
                          );
                        },
                      ),
                    );
                  }
                },
              ),

              SizedBox(height: 16),

              // Tombol panah untuk mengarahkan ke halaman lain
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    // Navigasi ke halaman menu kost
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => MenuKostPage()));
                  },
                ),
              ),

              // Section 2: Tempat Makan
            ],
          ),
        ),
      ),
    );
  }
}
