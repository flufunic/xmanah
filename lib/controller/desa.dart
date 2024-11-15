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
  }) async {
    try {
      // Add a new document to the 'desa' collection
      DocumentReference docRef = await desaCollection.add({
        'nama': nama,
        'kode_pos': kodePos,
        'alamat': alamat,
        'kontak': kontak,
      });

      print("Data desa berhasil ditambahkan!");

      // Return the ID of the new document
      return docRef.id; // Returning the ID of the newly added document
    } catch (e) {
      // Log the error and rethrow it
      print("Gagal menambahkan data desa: $e");
      throw Exception(
          "Gagal menambahkan data desa: $e"); // Rethrow the error for the UI to handle
    }
  }

  // Function to update existing "desa" data
  Future<void> updateDesa({
    required String desaId,
    required String nama,
    required String kodePos,
    required String alamat,
    required String kontak,
  }) async {
    try {
      // Update the document in the 'desa' collection
      await desaCollection.doc(desaId).update({
        'nama': nama,
        'kode_pos': kodePos,
        'alamat': alamat,
        'kontak': kontak,
      });

      print("Data desa berhasil diperbarui!");
    } catch (e) {
      // Log the error and rethrow it
      print("Gagal memperbarui data desa: $e");
      throw Exception(
          "Gagal memperbarui data desa: $e"); // Rethrow the error for the UI to handle
    }
  }

  // Fungsi untuk mengambil daftar desa
  Future<List<Map<String, dynamic>>> getDesaList() async {
    try {
      QuerySnapshot snapshot = await desaCollection.get(); // Ambil semua desa
      List<Map<String, dynamic>> desaList = snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
      return desaList;
    } catch (e) {
      print("Error fetching desa data: $e");
      return [];
    }
  }
}
