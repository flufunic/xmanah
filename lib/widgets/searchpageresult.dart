import 'package:flutter/material.dart';
import 'package:xmanah/usersview/inkost.dart';
import 'package:xmanah/usersview/intempatmakan.dart';
import 'package:xmanah/usersview/inkesehatan.dart';
import 'package:xmanah/usersview/inlembaga.dart';
import 'package:xmanah/usersview/intempatibadah.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  SearchResultsPage({required this.results});

  @override
  Widget build(BuildContext context) {
    // Pisahkan hasil pencarian berdasarkan kategori
    List<Map<String, dynamic>> desaResults = results.where((item) => item['type'] == 'desa').toList();
    List<Map<String, dynamic>> kostResults = results.where((item) => item['type'] == 'kost').toList();
    List<Map<String, dynamic>> tempatMakanResults = results.where((item) => item['type'] == 'tempatMakan').toList();
    List<Map<String, dynamic>> tempatIbadahResults = results.where((item) => item['type'] == 'tempatIbadah').toList();
    List<Map<String, dynamic>> lembagaPendidikanResults = results.where((item) => item['type'] == 'lembagaPendidikan').toList();
    List<Map<String, dynamic>> fasilitasKesehatanResults = results.where((item) => item['type'] == 'fasilitasKesehatan').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Pencarian'),
      ),
      body: results.isEmpty 
        ? Center(child: Text('Tidak ada hasil yang ditemukan'))
        : ListView(
        children: [
          if (desaResults.isNotEmpty) _buildSection('Desa', desaResults, context),
          if (kostResults.isNotEmpty) _buildSection('Kost', kostResults, context),
          if (tempatMakanResults.isNotEmpty) _buildSection('Tempat Makan', tempatMakanResults, context),
          if (tempatIbadahResults.isNotEmpty) _buildSection('Tempat Ibadah', tempatIbadahResults, context),
          if (lembagaPendidikanResults.isNotEmpty) _buildSection('Lembaga Pendidikan', lembagaPendidikanResults, context),
          if (fasilitasKesehatanResults.isNotEmpty) _buildSection('Fasilitas Kesehatan', fasilitasKesehatanResults, context),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return ListTile(
                title: Text(item['nama'] ?? item['name'] ?? 'Nama Tidak Tersedia'),
                subtitle: Text(_getSubtitle(item)),
                onTap: () {
                  // Navigate to appropriate detail page based on item type
                  _navigateToDetailPage(context, item);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // Metode untuk mendapatkan subtitle yang sesuai dengan tipe
  String _getSubtitle(Map<String, dynamic> item) {
    switch (item['type']) {
      case 'kost':
      case 'tempatMakan':
      case 'tempatIbadah':
      case 'lembagaPendidikan':
      case 'fasilitasKesehatan':
      case 'desa':
        return item['alamat'] ?? 'Alamat tidak tersedia';
      default:
        return 'Informasi tidak tersedia';
    }
  }

  // Metode untuk navigasi ke halaman detail sesuai tipe
  void _navigateToDetailPage(BuildContext context, Map<String, dynamic> item) {
    switch (item['type']) {
      case 'kost':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KostDetail(
              kostId: item['id'] ?? '',
              imageUrl: item['imageUrl'] ?? '',
              name: item['nama'] ?? item['name'] ?? '',
              address: item['alamat'] ?? '',
              kontak: item['kontak'] ?? '',
              harga: item['harga'] ?? 0,
              fasilitas: item['fasilitas'] ?? '',
            ),
          ),
        );
        break;
      case 'tempatMakan':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TempatMakanDetail( 
              makanId: item['id'] ?? '',
              imageUrl: item['imageUrl'] ?? '',
              name: item['nama'] ?? item['name'] ?? '',
              address: item['alamat'] ?? '',
              openingHours: '${item['jamBuka'] ?? "N/A"} - ${item['jamTutup'] ?? "N/A"}',
          ),
          ),
        );
        break;
      case 'tempatIbadah':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailTempatIbadah(data: item),
          ),
        );
        break;
      case 'lembagaPendidikan':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailLembagaPendidikan(data: item),
          ),
        );
        break;
      case 'fasilitasKesehatan':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailFasilitasKesehatan(data: item),
          ),
        );
        break;
      default:
        // Optional: Show a snackbar or toast if no detail page is available
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Detail tidak tersedia untuk jenis ini')),
        );
    }
  }
}