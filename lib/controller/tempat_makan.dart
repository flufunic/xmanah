import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TempatMakanService {
  final CollectionReference tempatMakanCollection =
      FirebaseFirestore.instance.collection('tempat_makan');
      

  // Method to add new tempat makan
  Future<void> tambahTempatMakan({
    required String nama,
    required String alamat,
    required TimeOfDay jamBuka, // Using TimeOfDay for open time
    required TimeOfDay jamTutup, // Using TimeOfDay for close time
    required String kontak,
    required String gambar,
    required String desaId, // Foreign Key from desa collection
  }) async {
    try {
     DocumentReference docRef = await tempatMakanCollection.add({
        'nama': nama,
        'alamat': alamat,
        'jamBuka': '${jamBuka.hour}:${jamBuka.minute}', // Convert to string
        'jamTutup': '${jamTutup.hour}:${jamTutup.minute}', // Convert to string
        'kontak': kontak,
        'gambar': gambar,
        'desa_id': desaId,
      });
      print("Tempat makan berhasil ditambahkan!");
    } catch (e) {
      print("Gagal menambahkan tempat makan: $e");
    }
  }

  // Method to update existing tempat makan
  Future<void> updateTempatMakan({
    required String tempatMakanId,
    required String nama,
    required String alamat,
    required TimeOfDay jamBuka, // Using TimeOfDay for open time
    required TimeOfDay jamTutup, // Using TimeOfDay for close time
    required String kontak,
    required String gambar,
    required String desaId, // Foreign Key from desa collection
  }) async {
    try {
      await tempatMakanCollection.doc(tempatMakanId).update({
        'nama': nama,
        'alamat': alamat,
        'jamBuka': '${jamBuka.hour}:${jamBuka.minute}', // Convert to string
        'jamTutup': '${jamTutup.hour}:${jamTutup.minute}', // Convert to string
        'kontak': kontak,
        'gambar': gambar,
        'desa_id': desaId,
      });
      print("Tempat makan berhasil diperbarui!");
    } catch (e) {
      print("Gagal memperbarui tempat makan: $e");
    }
  }

  // Method untuk mendapatkan daftar tempat makan
   Future<List<Map<String, dynamic>>> getTempatMakanList() async {
    try {
      QuerySnapshot querySnapshot = await tempatMakanCollection.get();
      List<Map<String, dynamic>> tempatMakanList = querySnapshot.docs.map((doc) { // Perbaiki di sini
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Tambahkan ID dokumen ke dalam data
        return data;
      }).toList();
      return tempatMakanList;
    } catch (e) {
      print("Gagal mengambil data tempat makan: $e");
      return [];
    }
  }

 // Method to get tempat makan list filtered by desa
   Future<List<Map<String, dynamic>>> getTempatMakanListByDesa(
      String desaId) async {
    try {
      QuerySnapshot snapshot = await tempatMakanCollection
          .where('desa_id', isEqualTo: desaId)
          .get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['type'] = 'tempatMakan';
        data['name'] = data['nama'];
        data['description'] = 'Buka ${data['jamBuka']} - ${data['jamTutup']}';
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching tempat makan data: $e");
      return [];
    }
  }

}
