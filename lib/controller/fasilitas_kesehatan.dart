import 'package:cloud_firestore/cloud_firestore.dart';

class FasilitasKesehatanService {
  final CollectionReference fasilitasKesehatanCollection =
      FirebaseFirestore.instance.collection('fasilitas_kesehatan');

  // Function to add a new health facility
  Future<void> tambahFasilitasKesehatan({
    required String nama,
    required String jenis, // jenis: Puskesmas, Klinik, Rumah Sakit
    required String alamat,
    required String kontak,
    required String gambar,
    required String desaId, // ID Desa
  }) async {
    try {
      // Pastikan tidak ada nilai null yang ditambahkan
      if (nama.isEmpty ||
          jenis.isEmpty ||
          alamat.isEmpty ||
          kontak.isEmpty ||
          gambar.isEmpty ||
          desaId.isEmpty) {
        throw 'Semua field harus diisi!';
      }

      await fasilitasKesehatanCollection.add({
        'nama': nama,
        'jenis': jenis,
        'alamat': alamat,
        'kontak': kontak,
        'gambar': gambar,
        'desa_id': desaId,
      });

      print("Fasilitas Kesehatan berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan fasilitas kesehatan: $e");
    }
  }

  // Function to update an existing health facility
  Future<void> updateFasilitasKesehatan({
    required String id,
    required String nama,
    required String jenis, // jenis: Puskesmas, Klinik, Rumah Sakit
    required String alamat,
    required String kontak,
    required String gambar,
    required String desaId, // ID Desa
  }) async {
    try {
      // Pastikan tidak ada nilai null yang ditambahkan
      if (nama.isEmpty ||
          jenis.isEmpty ||
          alamat.isEmpty ||
          kontak.isEmpty ||
          gambar.isEmpty ||
          desaId.isEmpty) {
        throw 'Semua field harus diisi!';
      }

      await fasilitasKesehatanCollection.doc(id).update({
        'nama': nama,
        'jenis': jenis,
        'alamat': alamat,
        'kontak': kontak,
        'gambar': gambar,
        'desa_id': desaId,
      });

      print("Fasilitas Kesehatan berhasil diperbarui!");
    } catch (e) {
      print("Gagal memperbarui fasilitas kesehatan: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getFasilitasKesehatanList() async {
    try {
      QuerySnapshot querySnapshot = await fasilitasKesehatanCollection.get();
      List<Map<String, dynamic>> fasilitasKesehatanList = [];
      querySnapshot.docs.forEach((doc) {
        fasilitasKesehatanList.add(doc.data() as Map<String, dynamic>);
      });
      return fasilitasKesehatanList;
    } catch (e) {
      print("Gagal mengambil data tempat makan: $e");
      return [];
    }
  }
}
