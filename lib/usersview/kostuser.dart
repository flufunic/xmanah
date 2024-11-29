import 'package:flutter/material.dart';
import 'package:xmanah/controller/kost.dart';
import 'package:xmanah/usersview/inkost.dart';

class KostUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final KostService kostService = KostService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Daftar Kost",
          style: TextStyle(color: Colors.black), // Ubah warna teks judul
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: kostService.getKostList(), // This returns a List of maps
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error fetching kost data"));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("Tidak ada data kost"));
          } else {
            final kostList = snapshot.data!;
            return ListView.builder(
              itemCount: kostList.length,
              itemBuilder: (context, index) {
                final kost = kostList[index];
                return KostCard(
                  imageUrl: kost['gambar'] ?? '',
                  name: kost['nama'] ?? 'Nama Kost',
                  address: kost['alamat'] ?? 'Alamat Kost',
                  review: kost['ulasan'] ?? 'Ulasan',
                  kontak: kost['kontak'] ?? 'Kontak',
                  fasilitas: kost['fasilitas'] ?? 'Fasilitas',
                  harga: kost['harga'] ?? 'Harga',
                );
              },
            );
          }
        },
      ),
    );
  }
}

class KostCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String address;
  final String review;
  final String kontak;
  final int harga;
  final String fasilitas;

  const KostCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.review,
    required this.kontak,
    required this.harga,
    required this.fasilitas,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KostDetail(
              imageUrl: imageUrl,
              name: name,
              address: address,
              review: review,
              kontak: kontak,
              harga: harga,
              fasilitas: fasilitas,
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
            // Gambar Kost
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
            // Nama, Alamat, dan Ulasan Kost
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
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.yellow[700],
                        size: 20.0,
                      ),
                      SizedBox(width: 4.0),
                      Text(
                        review,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
