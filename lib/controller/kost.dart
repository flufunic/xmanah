import 'package:cloud_firestore/cloud_firestore.dart';

class KostService {
  final CollectionReference kostCollection =
      FirebaseFirestore.instance.collection('kost');

  Future<void> tambahKost({
    required String nama,
    required String alamat,
    required String fasilitas,
    required String kontak,
    required int harga,
    required String ulasan,
    required String gambar,
    required String desaId, // Foreign Key dari koleksi desa
  }) async {
    try {
      await kostCollection.add({
        'nama': nama,
        'alamat': alamat,
        'fasilitas': fasilitas,
        'kontak': kontak,
        'harga': harga,
        'ulasan': ulasan,
        'gambar': gambar,
        'desa_id': desaId,
      });
      print("Data kost berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan data kost: $e");
    }
  }

  // Fungsi untuk mengambil daftar kost (dapat digunakan di UI)
  Future<List<Map<String, dynamic>>> getKostList() async {
    try {
      QuerySnapshot snapshot = await kostCollection.get();
      List<Map<String, dynamic>> kostList = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      return kostList;
    } catch (e) {
      print("Error fetching kost data: $e");
      return [];
    }
  }
}
