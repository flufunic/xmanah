import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xmanah/firstopen.dart';
import 'package:xmanah/home.dart';
import 'package:xmanah/views/desa/view_desa_page.dart';
import 'package:xmanah/views/fasilitas_kesehatan/view_fasilitas_kesehatan_page.dart';
import 'package:xmanah/views/kost/view_kost_page.dart';
import 'package:xmanah/views/lembaga_pendidikan/view_lembaga_pendidikan_page.dart';
import 'package:xmanah/views/tempat_ibadah/view_tempat_ibadah_page.dart';
import 'package:xmanah/views/tempat_makan/view_tempat_makan_page.dart';
import 'package:xmanah/views/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Service untuk mengambil data dari Firestore
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

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final DataService _dataService = DataService();
  int desaCount = 0;
  int tempatMakanCount = 0;
  int fasilitasKesehatanCount = 0;
  int tempatIbadahCount = 0;
  int kostCount = 0;
  int lembagaPendidikanCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchDataCounts();
  }

  Future<void> _fetchDataCounts() async {
    desaCount = await _dataService.getDesaCount();
    tempatMakanCount = await _dataService.getTempatMakanCount();
    fasilitasKesehatanCount = await _dataService.getFasilitasKesehatanCount();
    tempatIbadahCount = await _dataService.getTempatIbadahCount();
    kostCount = await _dataService.getKostCount();
    lembagaPendidikanCount = await _dataService.getLembagaPendidikanCount();

    setState(() {});
  }

  // Fungsi untuk logout
  Future<void> _logout(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FirtsOpen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard Admin'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF334d2b),
              ),
              child: Text(
                'Dashboard Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Desa'),
              subtitle: Text('Data: $desaCount'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DesaViewPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.restaurant),
              title: Text('Tempat Makan'),
              subtitle: Text('Data: $tempatMakanCount'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewTempatMakanPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.local_hospital),
              title: Text('Fasilitas Kesehatan'),
              subtitle: Text('Data: $fasilitasKesehatanCount'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewFasilitasKesehatanPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.church),
              title: Text('Tempat Ibadah'),
              subtitle: Text('Data: $tempatIbadahCount'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewTempatIbadahPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.hotel),
              title: Text('Kost'),
              subtitle: Text('Data: $kostCount'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewKostPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Lembaga Pendidikan'),
              subtitle: Text('Data: $lembagaPendidikanCount'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewLembagaPendidikanPage()),
                );
              },
            ),
            Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    _logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.white,
                      ),
                      SizedBox(width: 10),
                      Text('Logout',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Color(0xFF334d2b), // Background color #7da12d
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Selamat datang di Dashboard Admin Xmanah!',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                SizedBox(height: 20),
                // Card widgets untuk menampilkan jumlah data
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.blue[50],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Desa'),
                      subtitle: Text('Jumlah: $desaCount'),
                      leading: Icon(Icons.home, color: Colors.blue),
                    ),
                  ),
                ),
                // Card lainnya di sini
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.green[50],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Tempat Makan'),
                      subtitle: Text('Jumlah: $tempatMakanCount'),
                      leading: Icon(Icons.restaurant, color: Colors.green),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.red[50],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Fasilitas Kesehatan'),
                      subtitle: Text('Jumlah: $fasilitasKesehatanCount'),
                      leading: Icon(Icons.local_hospital, color: Colors.red),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.purple[50],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Tempat Ibadah'),
                      subtitle: Text('Jumlah: $tempatIbadahCount'),
                      leading: Icon(Icons.church, color: Colors.purple),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.orange[50],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Kost'),
                      subtitle: Text('Jumlah: $kostCount'),
                      leading: Icon(Icons.hotel, color: Colors.orange),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.yellow[50],
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text('Lembaga Pendidikan'),
                      subtitle: Text('Jumlah: $lembagaPendidikanCount'),
                      leading: Icon(Icons.school, color: Colors.yellow),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
