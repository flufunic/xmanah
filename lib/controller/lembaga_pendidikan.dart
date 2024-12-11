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
    required String gambar,
    required String desaId,
  }) async {
    try {
      await lembagaCollection.add({
        'nama': nama,
        'alamat': alamat,
        'akreditasi': akreditasi,
        'tingkat': tingkat,
        'kontak': kontak,
        'gambar': gambar,
        'desa_id': desaId,
      });
      print("Data lembaga pendidikan berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan data lembaga pendidikan: $e");
      rethrow;
    }
  }

  // Fungsi untuk memperbarui lembaga pendidikan
  Future<void> updateLembagaPendidikan({
    required String lembagaId, 
    required String nama,
    required String alamat,
    required String akreditasi,
    required String tingkat,
    required String kontak,
    required String gambar,
    required String desaId,
  }) async {
    try {
      await lembagaCollection.doc(lembagaId).update({
        'nama': nama,
        'alamat': alamat,
        'akreditasi': akreditasi,
        'tingkat': tingkat,
        'kontak': kontak,
        'gambar': gambar,
        'desa_id': desaId,
      });
      print("Data lembaga pendidikan berhasil diperbarui!");
    } catch (e) {
      print("Gagal memperbarui data lembaga pendidikan: $e");
      rethrow;
    }
  }

  // Get lembaga pendidikan by desaId
 Future<List<Map<String, dynamic>>> getLembagaPendidikanByDesa(String desaId) async {
    try {
      QuerySnapshot snapshot = await lembagaCollection
          .where('desa_id', isEqualTo: desaId)
          .get();

      List<Map<String, dynamic>> lembagaList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['type'] = 'lembagaPendidikan';
        data['name'] = data['nama'];
        data['description'] = '${data['tingkat']} - Akreditasi ${data['akreditasi']}';
        return data;
      }).toList();

      return lembagaList;
    } catch (e) {
      print("Gagal mengambil data lembaga pendidikan: $e");
      return [];
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
