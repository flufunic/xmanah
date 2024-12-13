import 'package:flutter/material.dart';
import 'package:xmanah/controller/kost.dart';
import 'package:xmanah/usersview/inkost.dart';

class KostUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final KostService kostService = KostService();

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Row(
            children: [
              Icon(Icons.home, color: Colors.white), // Ikon kost
              SizedBox(width: 8.0),
              Text(
                "Daftar Kost",
                style: TextStyle(
                  color: Colors.white, // Warna teks
                  fontSize: 18, // Ukuran teks
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Color(0xFF334d2b), // Warna background AppBar
        elevation: 0,
      ),
      backgroundColor: Color(0xFF334d2b), // Warna background halaman
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: kostService.getKostList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error fetching kost data",
                    style: TextStyle(color: Colors.white)));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(
                child: Text("Tidak ada data kost",
                    style: TextStyle(color: Colors.white)));
          } else {
            final kostList = snapshot.data!;
            return ListView.builder(
              itemCount: kostList.length,
              itemBuilder: (context, index) {
                final kost = kostList[index];
                return KostCard(
                  kostId: kost['id'] ?? '', // Add unique identifier
                  imageUrl: kost['gambar'] ?? '',
                  name: kost['nama'] ?? 'Nama Kost',
                  address: kost['alamat'] ?? 'Alamat Kost',
                  kontak: kost['kontak'] ?? 'Kontak',
                  fasilitas: kost['fasilitas'] ?? 'Fasilitas',
                  harga: kost['harga'] is int ? kost['harga'] : 0,
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
  final String kostId;
  final String imageUrl;
  final String name;
  final String address;
  final String kontak;
  final int harga;
  final String fasilitas;

  const KostCard({
    Key? key,
    required this.kostId,
    required this.imageUrl,
    required this.name,
    required this.address,
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
              kostId: kostId, // Pass kostId to detail page
              imageUrl: imageUrl,
              name: name,
              address: address,
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
          color: Colors.white, // Card berwarna putih
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
            // Kost Image
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
            // Kost Name and Address
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home,
                          size: 22, color: Color(0xFF334d2b)), // Ikon kost
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334d2b), // Teks berwarna
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
                          size: 20, color: Color(0xFF334d2b)), // Ikon lokasi
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          address,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF334d2b), // Teks berwarna
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.phone,
                          size: 20, color: Color(0xFF334d2b)), // Ikon kontak
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          kontak,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Color(0xFF334d2b), // Teks berwarna
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.money,
                          size: 20, color: Color(0xFF334d2b)), // Ikon harga
                      SizedBox(width: 8),
                      Text(
                        'Rp ${harga.toString()}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color(0xFF334d2b), // Teks berwarna
                          fontWeight: FontWeight.bold,
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
