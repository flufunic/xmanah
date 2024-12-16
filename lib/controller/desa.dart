import 'package:cloud_firestore/cloud_firestore.dart';

class DesaService {
  final CollectionReference desaCollection =
      FirebaseFirestore.instance.collection('desa');

  // Function to add new "desa" data
  Future<String> tambahDesa({
    required String nama,
    required String kodePos,
    required String alamat,
    required String kontak,
    required String gambar,
  }) async {
    try {
      DocumentReference docRef = await desaCollection.add({
        'nama': nama,
        'kode_pos': kodePos,
        'alamat': alamat,
        'kontak': kontak,
        'gambar': gambar,
      });
      print("Data desa berhasil ditambahkan!");
      return docRef.id;
    } catch (e) {
      print("Gagal menambahkan data desa: $e");
      throw Exception("Gagal menambahkan data desa: $e");
    }
  }

  // Function to update existing "desa" data
  Future<void> updateDesa({
    required String desaId,
    required String nama,
    required String kodePos,
    required String alamat,
    required String kontak,
    required String gambar,
  }) async {
    try {
      await desaCollection.doc(desaId).update({
        'nama': nama,
        'kode_pos': kodePos,
        'alamat': alamat,
        'kontak': kontak,
        'gambar': gambar,
      });
      print("Data desa berhasil diperbarui!");
    } catch (e) {
      print("Gagal memperbarui data desa: $e");
      throw Exception("Gagal memperbarui data desa: $e");
    }
  }

  // Fungsi untuk mengambil daftar desa
  Future<List<Map<String, dynamic>>> getDesaList() async {
    try {
      QuerySnapshot snapshot = await desaCollection.get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching desa data: $e");
      return [];
    }
  }
  // Fungsi untuk mencari desa berdasarkan nama
  Future<List<Map<String, dynamic>>> searchDesa(String query) async {
    try {
      QuerySnapshot snapshot = await desaCollection
          .where('nama', isGreaterThanOrEqualTo: query)
          .where('nama', isLessThanOrEqualTo: query + '\uf8ff')
          .get();

      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("Error searching desa data: $e");
      return [];
    }
  }
}
