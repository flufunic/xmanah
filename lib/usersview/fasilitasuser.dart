import 'package:flutter/material.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';
import 'package:xmanah/controller/tempat_ibadah.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart'; 
import 'package:xmanah/usersview/inkesehatan.dart';
import 'package:xmanah/usersview/inlembaga.dart';
import 'package:xmanah/usersview/intempatibadah.dart';

class FasilitasUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Inisialisasi layanan
    final lembagaPendidikanService = LembagaPendidikanService();
    final tempatIbadahService = TempatIbadahService();
    final fasilitasKesehatanService = FasilitasKesehatanService();

    return DefaultTabController(
      length: 3, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: kToolbarHeight - 50, // Tinggi AppBar
          automaticallyImplyLeading: false, // Hilangkan ikon back
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pendidikan'),
              Tab(text: 'Tempat Ibadah'),
              Tab(text: 'Kesehatan'),
            ],
            indicatorColor: Colors.purple[200], // Indikator tab aktif
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey[800],
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            // Konten tiap tab
            LembagaList(
              service: lembagaPendidikanService,
              category: 'Pendidikan',
            ),
            LembagaList(
              service: tempatIbadahService,
              category: 'Tempat Ibadah',
            ),
            LembagaList(
              service: fasilitasKesehatanService,
              category: 'Kesehatan',
            ),
          ],
        ),
      ),
    );
  }
}

class LembagaList extends StatelessWidget {
  final dynamic service;
  final String category;

  LembagaList({required this.service, required this.category});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: category == 'Tempat Ibadah'
          ? service.getTempatIbadahList() // Perbaikan: getTempatIbadaList -> getTempatIbadahList
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
                openingHours: lembaga['jamBuka'] ?? '',
                closedHours: lembaga['jamTutup'] ?? '',
                kontak: lembaga['kontak'] ?? '',
                onTap: () {
                  // Navigasi ke halaman detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => category == 'Pendidikan'
                          ? DetailLembagaPendidikan(data: lembaga) // Perbaikan: lembaga -> data
                          : category == 'Tempat Ibadah'
                              ? DetailTempatIbadah(data: lembaga)
                              : category == 'Kesehatan'
                              ? DetailFasilitasKesehatan(data: lembaga) // Perbaikan: parameter tetap data
                              : DetailPage(lembaga: lembaga), // for Kesehatan or other categories
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
                      color: Colors.grey[300],
                      child: Icon(Icons.image, color: Colors.white, size: 40),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.0),
                  Text(address, style: TextStyle(fontSize: 16.0)),
                  SizedBox(height: 8.0),
                  if (akreditasi.isNotEmpty) Text("Akreditasi: $akreditasi"),
                  if (tingkat.isNotEmpty) Text("Tingkat: $tingkat"),
                  if (jenis.isNotEmpty) Text("Jenis: $jenis"),
                  if (openingHours.isNotEmpty)
                    Text("Jam Buka: $openingHours"),
                  if (closedHours.isNotEmpty)
                    Text("Jam Tutup: $closedHours"),
                  Text("Kontak: $kontak"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Map<String, dynamic> lembaga;

  DetailPage({required this.lembaga});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lembaga['nama'] ?? 'Detail')),
      body: Center(
        child: Text("Detail informasi tentang ${lembaga['nama']}"),
      ),
    );
  }
}