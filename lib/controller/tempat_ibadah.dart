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
    required String ulasan,
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
        'ulasan': ulasan,
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
    required String ulasan,
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
        'ulasan': ulasan,
        'desa_id': desaId,
      });
      print("Tempat Ibadah berhasil diperbarui!");
    } catch (e) {
      print("Gagal memperbarui tempat ibadah: $e");
    }
  }
}
