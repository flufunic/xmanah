import 'package:cloud_firestore/cloud_firestore.dart';

class FasilitasKesehatanService {
  final CollectionReference fasilitasKesehatanCollection =
      FirebaseFirestore.instance.collection('fasilitas_kesehatan');

  Future<void> tambahFasilitasKesehatan({
    required String nama,
    required String jenis, // jenis: Puskesmas, Klinik, Rumah Sakit
    required String alamat,
    required String kontak,
    required String ulasan,
    required String desaId, // ID Desa
  }) async {
    try {
      await fasilitasKesehatanCollection.add({
        'nama': nama,
        'jenis': jenis,
        'alamat': alamat,
        'kontak': kontak,
        'ulasan': ulasan,
        'desa_id': desaId,
      });
      print("Fasilitas Kesehatan berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan fasilitas kesehatan: $e");
    }
  }
}
