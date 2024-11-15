import 'package:cloud_firestore/cloud_firestore.dart';

class LembagaPendidikanService {
  final CollectionReference lembagaCollection =
      FirebaseFirestore.instance.collection('lembaga_pendidikan');

  // Fungsi untuk menambah lembaga pendidikan
  Future<void> tambahLembagaPendidikan({
    required String nama,
    required String alamat,
    required String akreditasi, // Akreditasi (unggul, a, b, c)
    required String tingkat, // Tingkat (sd, smp, sma/k, universitas)
    required String kontak,
    required String ulasan,
    required String desaId,
  }) async {
    try {
      await lembagaCollection.add({
        'nama': nama,
        'alamat': alamat,
        'akreditasi': akreditasi,
        'tingkat': tingkat,
        'kontak': kontak,
        'ulasan': ulasan,
        'desa_id': desaId,
      });
      print("Data lembaga pendidikan berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan data lembaga pendidikan: $e");
      rethrow; // Rethrow the error so that it can be handled by the caller
    }
  }

  // Fungsi untuk memperbarui lembaga pendidikan
  Future<void> updateLembagaPendidikan({
    required String lembagaId, // ID lembaga yang akan diperbarui
    required String nama,
    required String alamat,
    required String akreditasi,
    required String tingkat,
    required String kontak,
    required String ulasan,
    required String desaId,
  }) async {
    try {
      await lembagaCollection.doc(lembagaId).update({
        'nama': nama,
        'alamat': alamat,
        'akreditasi': akreditasi,
        'tingkat': tingkat,
        'kontak': kontak,
        'ulasan': ulasan,
        'desa_id': desaId,
      });
      print("Data lembaga pendidikan berhasil diperbarui!");
    } catch (e) {
      print("Gagal memperbarui data lembaga pendidikan: $e");
      rethrow; // Rethrow the error so that it can be handled by the caller
    }
  }

  Future<List<Map<String, dynamic>>> getLembagaPendidikanList() async {
    try {
      QuerySnapshot querySnapshot = await lembagaCollection.get();
      List<Map<String, dynamic>> lembagaPendidikanList = [];
      querySnapshot.docs.forEach((doc) {
        lembagaPendidikanList.add(doc.data() as Map<String, dynamic>);
      });
      return lembagaPendidikanList;
    } catch (e) {
      print("Gagal mengambil data lembaga pendidikan: $e");
      return [];
    }
  }
}
