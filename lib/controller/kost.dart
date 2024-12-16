import 'package:cloud_firestore/cloud_firestore.dart';

class KostService {
  final CollectionReference kostCollection =
      FirebaseFirestore.instance.collection('kost');

  // Function to add new "kost" data
  Future<void> tambahKost({
    required String nama,
    required String alamat,
    required String fasilitas,
    required String kontak,
    required int harga,
    required String gambar,
    required String desaId,
  }) async {
    try {
      DocumentReference docRef = await kostCollection.add({
        'nama': nama,
        'alamat': alamat,
        'fasilitas': fasilitas,
        'kontak': kontak,
        'harga': harga,
        'gambar': gambar,
        'desa_id': desaId,
      });

      print("Data kost berhasil ditambahkan dengan ID: ${docRef.id}");
    } catch (e) {
      print("Gagal menambahkan data kost: $e");
    }
  }

  // Fungsi untuk mengambil daftar kost (dapat digunakan di UI)
  Future<List<Map<String, dynamic>>> getKostList() async {
    try {
      QuerySnapshot snapshot = await kostCollection.get();
      List<Map<String, dynamic>> kostList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Tambahkan ID dokumen ke dalam data
        return data;
      }).toList();

      return kostList;
    } catch (e) {
      print("Error fetching kost data: $e");
      return [];
    }
  }

  // Function to get kost by desaId (only one declaration should exist)
   Future<List<Map<String, dynamic>>> getKostListByDesa(String desaId) async {
    try {
      QuerySnapshot snapshot = await kostCollection
          .where('desa_id', isEqualTo: desaId)
          .get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['type'] = 'kost';
        data['name'] = data['nama'];
        data['description'] = 'Kost dengan alamat ${data['alamat']}';
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching kost data: $e");
      return [];
    }
  }

  // Function to update existing "kost" data
  Future<void> updateKost({
    required String kostId,
    required String nama,
    required String alamat,
    required String fasilitas,
    required String kontak,
    required int harga,
    required String gambar,
    required String desaId,
  }) async {
    try {
      await kostCollection.doc(kostId).update({
        'nama': nama,
        'alamat': alamat,
        'fasilitas': fasilitas,
        'kontak': kontak,
        'harga': harga,
        'gambar': gambar,
        'desa_id': desaId,
      });
      print("Data kost berhasil diperbarui!");
    } catch (e) {
      print("Gagal memperbarui data kost: $e");
    }
  }
}
