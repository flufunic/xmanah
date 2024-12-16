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
    List<Map<String, dynamic>> desaResults =
        results.where((item) => item['type'] == 'desa').toList();
    List<Map<String, dynamic>> kostResults =
        results.where((item) => item['type'] == 'kost').toList();
    List<Map<String, dynamic>> tempatMakanResults =
        results.where((item) => item['type'] == 'tempatMakan').toList();
    List<Map<String, dynamic>> tempatIbadahResults =
        results.where((item) => item['type'] == 'tempatIbadah').toList();
    List<Map<String, dynamic>> lembagaPendidikanResults =
        results.where((item) => item['type'] == 'lembagaPendidikan').toList();
    List<Map<String, dynamic>> fasilitasKesehatanResults =
        results.where((item) => item['type'] == 'fasilitasKesehatan').toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF334d2b),
        title: Text('Hasil Pencarian', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        color: Color(0xFF334d2b),
        child: results.isEmpty
            ? Center(
                child: Text(
                  'Tidak ada hasil yang ditemukan',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : ListView(
                children: [
                  if (desaResults.isNotEmpty)
                    _buildSection('Desa', desaResults, context),
                  if (kostResults.isNotEmpty)
                    _buildSection('Kost', kostResults, context),
                  if (tempatMakanResults.isNotEmpty)
                    _buildSection('Tempat Makan', tempatMakanResults, context),
                  if (tempatIbadahResults.isNotEmpty)
                    _buildSection(
                        'Tempat Ibadah', tempatIbadahResults, context),
                  if (lembagaPendidikanResults.isNotEmpty)
                    _buildSection('Lembaga Pendidikan',
                        lembagaPendidikanResults, context),
                  if (fasilitasKesehatanResults.isNotEmpty)
                    _buildSection('Fasilitas Kesehatan',
                        fasilitasKesehatanResults, context),
                ],
              ),
      ),
    );
  }

  Widget _buildSection(
      String title, List<Map<String, dynamic>> items, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 6.0),
                color: Colors.white,
                child: ListTile(
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200],
                      image: DecorationImage(
                        image: NetworkImage(item['gambar'] ??
                            'https://via.placeholder.com/150'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(
                    item['nama'] ?? item['name'] ?? 'Nama Tidak Tersedia',
                    style: TextStyle(
                        color: Color(0xFF334d2b), fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    _getSubtitle(item),
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios,
                      color: Color(0xFF334d2b), size: 16),
                  onTap: () {
                    _navigateToDetailPage(context, item);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getSubtitle(Map<String, dynamic> item) {
    return item['alamat'] ?? 'Alamat tidak tersedia';
  }

  void _navigateToDetailPage(BuildContext context, Map<String, dynamic> item) {
    switch (item['type']) {
      case 'kost':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KostDetail(
              kostId: item['id'] ?? '',
              imageUrl: item['gambar'] ?? '',
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
              imageUrl: item['gambar'] ?? '',
              name: item['nama'] ?? item['name'] ?? '',
              address: item['alamat'] ?? '',
              openingHours:
                  '${item['jamBuka'] ?? "N/A"} - ${item['jamTutup'] ?? "N/A"}',
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Detail tidak tersedia untuk jenis ini')),
        );
    }
  }
}
