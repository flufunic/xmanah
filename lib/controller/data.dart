import 'package:cloud_firestore/cloud_firestore.dart';

class DataService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<int> getDesaCount() async {
    var snapshot = await _db.collection('desa').get();
    return snapshot.docs.length;
  }

  Future<int> getTempatMakanCount() async {
    var snapshot = await _db.collection('tempat_makan').get();
    return snapshot.docs.length;
  }

  Future<int> getFasilitasKesehatanCount() async {
    var snapshot = await _db.collection('fasilitas_kesehatan').get();
    return snapshot.docs.length;
  }

  Future<int> getTempatIbadahCount() async {
    var snapshot = await _db.collection('tempat_ibadah').get();
    return snapshot.docs.length;
  }

  Future<int> getKostCount() async {
    var snapshot = await _db.collection('kost').get();
    return snapshot.docs.length;
  }

  Future<int> getLembagaPendidikanCount() async {
    var snapshot = await _db.collection('lembaga_pendidikan').get();
    return snapshot.docs.length;
  }
}
