import 'package:cloud_firestore/cloud_firestore.dart';

class DesaService {
  final CollectionReference desaCollection =
      FirebaseFirestore.instance.collection('desa');

  Future<void> tambahDesa({
    required String nama,
    required String kodePos,
    required String alamat,
    required String kontak,
  }) async {
    try {
      await desaCollection.add({
        'nama': nama,
        'kode_pos': kodePos,
        'alamat': alamat,
        'kontak': kontak,
      });
      print("Data desa berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan data desa: $e");
    }
  }
}
