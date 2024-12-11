import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TempatIbadahService {
  final CollectionReference tempatIbadahCollection =
      FirebaseFirestore.instance.collection('tempat_ibadah');

  // Add Tempat Ibadah
  Future<void> tambahTempatIbadah({
    required String nama,
    required String kategori,
    required String alamat,
    required TimeOfDay jamBuka,
    required TimeOfDay jamTutup,
    required String kontak,
    required String gambar,
    required String desaId,
  }) async {
    try {
      await tempatIbadahCollection.add({
        'nama': nama,
        'kategori': kategori,
        'alamat': alamat,
        'jamBuka': '${jamBuka.hour}:${jamBuka.minute}', // Convert to string
        'jamTutup': '${jamTutup.hour}:${jamTutup.minute}', // Convert to string
        'kontak': kontak,
        'gambar': gambar,
        'desa_id': desaId,
      });
      print("Tempat Ibadah berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan tempat ibadah: $e");
    }
  }

  // Update Tempat Ibadah (New method for updating)
  Future<void> updateTempatIbadah({
    required String tempatIbadahId, // ID of the tempat ibadah to be updated
    required String nama,
    required String kategori,
    required String alamat,
    required TimeOfDay jamBuka,
    required TimeOfDay jamTutup,
    required String kontak,
    required String gambar,
    required String desaId,
  }) async {
    try {
      await tempatIbadahCollection.doc(tempatIbadahId).update({
        'nama': nama,
        'kategori': kategori,
        'alamat': alamat,
        'jamBuka': '${jamBuka.hour}:${jamBuka.minute}', // Convert to string
        'jamTutup': '${jamTutup.hour}:${jamTutup.minute}', // Convert to string
        'kontak': kontak,
        'gambar': gambar,
        'desa_id': desaId,
      });
      print("Tempat Ibadah berhasil diperbarui!");
    } catch (e) {
      print("Gagal memperbarui tempat ibadah: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getTempatIbadahList() async {
    try {
      QuerySnapshot querySnapshot = await tempatIbadahCollection.get();
      List<Map<String, dynamic>> tempatIbadahList = [];
      querySnapshot.docs.forEach((doc) {
        tempatIbadahList.add(doc.data() as Map<String, dynamic>);
      });
      return tempatIbadahList;
    } catch (e) {
      print("Gagal mengambil data tempat makan: $e");
      return [];
    }
  }
    Future<List<Map<String, dynamic>>> getTempatIbadahListByDesa(String desaId) async {
    try {
      QuerySnapshot snapshot = await tempatIbadahCollection
          .where('desa_id', isEqualTo: desaId)
          .get();

      List<Map<String, dynamic>> tempatIbadahList = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['type'] = 'tempatIbadah';
        data['name'] = data['nama'];
        data['description'] = '${data['kategori']} di ${data['alamat']}';
        return data;
      }).toList();

      return tempatIbadahList;
    } catch (e) {
      print("Error fetching tempat ibadah data: $e");
      return [];
    }
  }
}

