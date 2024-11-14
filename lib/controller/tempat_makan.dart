import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TempatMakanService {
  final CollectionReference tempatMakanCollection =
      FirebaseFirestore.instance.collection('tempat_makan');

  Future<void> tambahTempatMakan({
    required String nama,
    required String alamat,
    required TimeOfDay jamBuka, // Menggunakan TimeOfDay untuk jam buka
    required TimeOfDay jamTutup, // Menggunakan TimeOfDay untuk jam tutup
    required String kontak,
    required String ulasan,
    required String desaId, // Foreign Key dari koleksi desa
  }) async {
    try {
      await tempatMakanCollection.add({
        'nama': nama,
        'alamat': alamat,
        'jamBuka': '${jamBuka.hour}:${jamBuka.minute}', // Convert to string
        'jamTutup': '${jamTutup.hour}:${jamTutup.minute}', // Convert to string
        'kontak': kontak,
        'ulasan': ulasan,
        'desa_id': desaId,
      });
      print("Tempat makan berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan tempat makan: $e");
    }
  }
}
