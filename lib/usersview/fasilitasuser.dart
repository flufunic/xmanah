import 'package:flutter/material.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';
import 'package:xmanah/controller/tempat_ibadah.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart';
import 'package:xmanah/usersview/inkesehatan.dart';
import 'package:xmanah/usersview/inlembaga.dart';
import 'package:xmanah/usersview/intempatibadah.dart'; // Import halaman detail fasilitas kesehatan

class FasilitasUser extends StatefulWidget {
  @override
  _FasilitasUserState createState() => _FasilitasUserState();
}

class _FasilitasUserState extends State<FasilitasUser> {
  int selectedIndex = 0;

  final List<String> tabs = ["Pendidikan", "Ibadah", "Kesehatan"];
  final lembagaPendidikanService = LembagaPendidikanService();
  final tempatIbadahService = TempatIbadahService();
  final fasilitasKesehatanService = FasilitasKesehatanService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF334d2b),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            tabs.length,
            (index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? Color(0xFF334d2b)
                      : Colors.grey[300],
                  borderRadius:
                      BorderRadius.circular(20), // Bentuk oval lebih kecil
                ),
                child: Row(
                  children: [
                    Icon(
                      index == 0
                          ? Icons.school
                          : index == 1
                              ? Icons.mosque
                              : Icons.local_hospital,
                      size: 16, // Ukuran ikon lebih kecil
                      color: selectedIndex == index
                          ? Colors.white
                          : Colors.black54,
                    ),
                    SizedBox(width: 5),
                    Text(
                      tabs[index],
                      style: TextStyle(
                        fontSize: 12.0, // Ukuran teks lebih kecil
                        color: selectedIndex == index
                            ? Colors.white
                            : Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFF334d2b),
      body: IndexedStack(
        index: selectedIndex,
        children: [
          ContentTab(
            service: lembagaPendidikanService,
            category: 'Pendidikan',
          ),
          ContentTab(
            service: tempatIbadahService,
            category: 'Tempat Ibadah',
          ),
          ContentTab(
            service: fasilitasKesehatanService,
            category: 'Kesehatan',
          ),
        ],
      ),
    );
  }
}

class ContentTab extends StatelessWidget {
  final dynamic service;
  final String category;

  const ContentTab({required this.service, required this.category});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: category == 'Tempat Ibadah'
          ? service.getTempatIbadahList()
          : category == 'Kesehatan'
              ? service.getFasilitasKesehatanList()
              : service.getLembagaPendidikanList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Terjadi kesalahan saat mengambil data"));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text("Tidak ada data tersedia"));
        } else {
          final lembagaList = snapshot.data!;
          return ListView.builder(
            itemCount: lembagaList.length,
            itemBuilder: (context, index) {
              final lembaga = lembagaList[index];
              return FasilitasCard(
                imageUrl: lembaga['gambar'] ?? '',
                name: lembaga['nama'] ?? '',
                address: lembaga['alamat'] ?? '',
                akreditasi: lembaga['akreditasi'] ?? '',
                tingkat: lembaga['tingkat'] ?? '',
                jenis: lembaga['jenis'] ?? '',
                kontak: lembaga['kontak'] ?? '',
                openingHours: lembaga['jamBuka'] ?? '',
                closedHours: lembaga['jamTutup'] ?? '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        // Navigasi ke halaman detail yang sesuai berdasarkan kategori
                        if (category == 'Pendidikan') {
                          return DetailLembagaPendidikan(data: lembaga);
                        } else if (category == 'Tempat Ibadah') {
                          return DetailTempatIbadah(data: lembaga);
                        } else {
                          return DetailFasilitasKesehatan(data: lembaga);
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

class FasilitasCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String address;
  final String akreditasi;
  final String tingkat;
  final String jenis;
  final String kontak;
  final String openingHours;
  final String closedHours;
  final VoidCallback onTap;

  const FasilitasCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.akreditasi,
    required this.tingkat,
    required this.jenis,
    required this.kontak,
    required this.openingHours,
    required this.closedHours,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10.0),
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
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      height: 150, // Disesuaikan untuk tampilan mobile
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, color: Colors.white, size: 30),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.school, size: 16, color: Color(0xFF334d2b)),
                      SizedBox(width: 8),
                      Text(
                        name,
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334d2b)),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Color(0xFF334d2b)),
                      SizedBox(width: 8),
                      Text(address,
                          style: TextStyle(
                              fontSize: 14.0, color: Color(0xFF334d2b))),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Color(0xFF334d2b)),
                      SizedBox(width: 8),
                      Text(
                        "Kontak: $kontak",
                        style: TextStyle(color: Color(0xFF334d2b)),
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
