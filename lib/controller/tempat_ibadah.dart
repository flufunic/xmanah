import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TempatIbadahService {
  final CollectionReference tempatIbadahCollection =
      FirebaseFirestore.instance.collection('tempat_ibadah');

  Future<void> tambahTempatIbadah({
    required String nama,
    required String
        kategori, // kategori: masjid, klenteng, vihara, gereja, pura
    required String alamat,
    required TimeOfDay jamBuka, // Menggunakan TimeOfDay untuk jam buka
    required TimeOfDay jamTutup, // Menggunakan TimeOfDay untuk jam tutup
    required String kontak,
    required String ulasan,
    required String desaId, // Foreign Key dari koleksi desa
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
}
