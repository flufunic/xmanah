import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final List<Map<String, dynamic>> results;

  SearchResultsPage({required this.results});

  @override
  Widget build(BuildContext context) {
    // Pisahkan hasil pencarian berdasarkan kategori
    List<Map<String, dynamic>> kostResults = results.where((item) => item['type'] == 'kost').toList();
    List<Map<String, dynamic>> tempatMakanResults = results.where((item) => item['type'] == 'tempatMakan').toList();
    List<Map<String, dynamic>> tempatIbadahResults = results.where((item) => item['type'] == 'tempatIbadah').toList();
    List<Map<String, dynamic>> lembagaPendidikanResults = results.where((item) => item['type'] == 'lembagaPendidikan').toList();
    List<Map<String, dynamic>> fasilitasKesehatanResults = results.where((item) => item['type'] == 'fasilitasKesehatan').toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Pencarian'),
      ),
      body: ListView(
        children: [
          if (kostResults.isNotEmpty) _buildSection('Kost', kostResults),
          if (tempatMakanResults.isNotEmpty) _buildSection('Tempat Makan', tempatMakanResults),
          if (tempatIbadahResults.isNotEmpty) _buildSection('Tempat Ibadah', tempatIbadahResults),
          if (lembagaPendidikanResults.isNotEmpty) _buildSection('Lembaga Pendidikan', lembagaPendidikanResults),
          if (fasilitasKesehatanResults.isNotEmpty) _buildSection('Fasilitas Kesehatan', fasilitasKesehatanResults),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items) {
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
                title: Text(item['name'] ?? 'Unknown'),
                subtitle: Text(item['description'] ?? 'No description available'),
                onTap: () {
                  // Handle item tap, navigate to details page
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
