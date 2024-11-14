import 'package:cloud_firestore/cloud_firestore.dart';

class LembagaPendidikanService {
  final CollectionReference lembagaCollection =
      FirebaseFirestore.instance.collection('lembaga_pendidikan');

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
    }
  }
}
