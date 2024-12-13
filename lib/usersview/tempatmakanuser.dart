import 'package:flutter/material.dart';
import 'package:xmanah/controller/tempat_makan.dart';
import 'package:xmanah/usersview/intempatmakan.dart';

class TempatMakanUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TempatMakanService tempatMakanService = TempatMakanService();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0), // Tentukan tinggi AppBar
        child: AppBar(
          title: Padding(
            padding: EdgeInsets.only(left: 16.0), // Berikan padding kiri
            child: Row(
              children: [
                Icon(Icons.fastfood, color: Colors.white), // Ikon makanan
                SizedBox(width: 8.0), // Memberikan jarak antara ikon dan teks
                Text(
                  "Tempat Makan",
                  style: TextStyle(
                    color: Colors.white, // Warna teks
                    fontSize: 18, // Ukuran teks yang lebih kecil
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xFF334d2b), // Warna background AppBar
          elevation: 0, // Hilangkan shadow
        ),
      ),
      backgroundColor: Color(0xFF334d2b),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: tempatMakanService.getTempatMakanList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error fetching tempat makan data",
                    style: TextStyle(color: Colors.white)));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
                child: Text("Tidak ada data tempat makan",
                    style: TextStyle(color: Colors.white)));
          } else {
            final tempatMakanList = snapshot.data!;
            return ListView.builder(
              itemCount: tempatMakanList.length,
              itemBuilder: (context, index) {
                final tempatMakan = tempatMakanList[index];
                final jamBuka = tempatMakan['jamBuka'];
                final jamTutup = tempatMakan['jamTutup'];

                return TempatMakanCard(
                  makanId: tempatMakan['id'] ?? '',
                  imageUrl: tempatMakan['gambar'] ?? '',
                  name: tempatMakan['nama'] ?? 'Nama Tempat Makan',
                  address: tempatMakan['alamat'] ?? 'Alamat tidak tersedia',
                  openingHours: '$jamBuka - $jamTutup',
                );
              },
            );
          }
        },
      ),
    );
  }
}

class TempatMakanCard extends StatelessWidget {
  final String makanId;
  final String imageUrl;
  final String name;
  final String address;
  final String openingHours;

  const TempatMakanCard({
    Key? key,
    required this.makanId,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.openingHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TempatMakanDetail(
              makanId: makanId, // Pass makanId to detail page
              imageUrl: imageUrl,
              name: name,
              address: address,
              openingHours: openingHours,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white, // Card dengan warna putih
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tempat Makan Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.0)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 180,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, color: Colors.white, size: 40),
                    ),
            ),
            // Tempat Name and Address
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fastfood,
                          size: 22,
                          color:
                              Color(0xFF334d2b)), // Ikon dengan warna kontras
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color:
                                Color(0xFF334d2b), // Nama dengan warna kontras
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 20,
                          color:
                              Color(0xFF334d2b)), // Ikon dengan warna kontras
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xFF334d2b)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 20,
                          color:
                              Color(0xFF334d2b)), // Ikon dengan warna kontras
                      SizedBox(width: 8),
                      Text(
                        openingHours,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF334d2b),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
