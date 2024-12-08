import 'package:flutter/material.dart';
import 'package:xmanah/controller/tempat_makan.dart';
import 'package:xmanah/usersview/intempatmakan.dart';


class TempatMakanUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TempatMakanService tempatMakanService = TempatMakanService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Tempat Makan",
          style: TextStyle(color: Colors.black), // Ubah warna teks judul
        ),
        backgroundColor: Colors.white,
        elevation: 0, // Ubah warna AppBar menjadi putih
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: tempatMakanService
            .getTempatMakanList(), // Mendapatkan daftar tempat makan
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching tempat makan data"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("Tidak ada data tempat makan"));
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
              openingHours:openingHours,
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
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
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
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
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8.0),
                  // Optional: Add price information
                 Text(
                    openingHours,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
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