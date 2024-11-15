import 'package:flutter/material.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';
import 'package:xmanah/controller/tempat_ibadah.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart'; // Import FasilitasKesehatanService

class FasilitasUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final LembagaPendidikanService lembagaPendidikanService =
        LembagaPendidikanService();
    final TempatIbadahService tempatIbadahService = TempatIbadahService();
    final FasilitasKesehatanService fasilitasKesehatanService =
        FasilitasKesehatanService();

    return DefaultTabController(
      length: 3, // Jumlah tab
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight:
              kToolbarHeight - 50, // Kurangi tinggi AppBar jika diperlukan
          automaticallyImplyLeading:
              false, // Hilangkan ikon default pada AppBar
          backgroundColor:
              Colors.white, // Ubah sesuai warna latar yang Anda inginkan
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pendidikan'),
              Tab(text: 'Tempat Ibadah'),
              Tab(text: 'Kesehatan'),
            ],
            indicatorColor: Colors.purple[200], // Warna indikator tab aktif
            labelColor: Colors.black, // Warna teks tab aktif
            unselectedLabelColor:
                Colors.grey[800], // Warna teks tab tidak aktif
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: TabBarView(
          children: [
            // Konten untuk masing-masing tab
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
  final dynamic
      service; // Bisa LembagaPendidikanService, TempatIbadahService, atau FasilitasKesehatanService
  final String category;

  LembagaList({required this.service, required this.category});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: category == 'Tempat Ibadah'
          ? service.getTempatIbadaList()
          : category == 'Kesehatan'
              ? service.getFasilitasKesehatanList()
              : service.getLembagaPendidikanList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error fetching data"));
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return Center(child: Text("Tidak ada data"));
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
                review: lembaga['ulasan'] ?? '',
                akreditasi: lembaga.containsKey('akreditasi')
                    ? lembaga['akreditasi'] ?? ''
                    : '',
                tingkat: lembaga.containsKey('tingkat')
                    ? lembaga['tingkat'] ?? ''
                    : '',
                kontak: lembaga['kontak'] ?? '',
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
  final String review;
  final String akreditasi;
  final String tingkat;
  final String kontak;

  const FasilitasCard({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.review,
    required this.akreditasi,
    required this.tingkat,
    required this.kontak,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
                    child: Center(child: Text("No Image")),
                  ),
          ),
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
                if (akreditasi.isNotEmpty)
                  Text(
                    "Akreditasi: $akreditasi",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                if (tingkat.isNotEmpty)
                  Text(
                    "Tingkat: $tingkat",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                SizedBox(height: 8.0),
                Text(
                  "Kontak: $kontak",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
