import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xmanah/home.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart';
import 'package:xmanah/views/admin_page.dart';
import 'package:xmanah/views/desa/edit_desa_page.dart';
import 'package:xmanah/views/desa/tambah_desa_page.dart';
import 'package:xmanah/views/desa/view_desa_page.dart';
import 'package:xmanah/views/fasilitas_kesehatan/tambah_fasilitas_kesehatan_page.dart';
import 'package:xmanah/views/fasilitas_kesehatan/view_fasilitas_kesehatan_page.dart';
import 'package:xmanah/views/kost/tambah_kost_page.dart';
import 'package:xmanah/views/kost/view_kost_page.dart';
import 'package:xmanah/views/lembaga_pendidikan/tambah_lembaga_pendidikan_page.dart';

import 'package:xmanah/widgets/navbar.dart';

import 'package:xmanah/views/lembaga_pendidikan/view_lembaga_pendidikan_page.dart';
import 'package:xmanah/views/login_page.dart';
import 'package:xmanah/views/tempat_ibadah/tambah_tempat_ibadah_page.dart';
import 'package:xmanah/views/tempat_ibadah/view_tempat_ibadah_page.dart';
import 'package:xmanah/views/tempat_makan/tambah_tempat_makan_page.dart';
import 'package:xmanah/views/tempat_makan/view_tempat_makan_page.dart';

import 'firebase_options.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavBarExample(),
    );
  }
}

class BottomNavBarExample extends StatefulWidget {
  @override
  _BottomNavBarExampleState createState() => _BottomNavBarExampleState();
}

class _BottomNavBarExampleState extends State<BottomNavBarExample> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    TambahKostPage(),
    TambahFasilitasKesehatanPage(),
    TambahTempatMakanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavbar(), // Use CustomNavbar here
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apartment),
            label: 'Kost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Fasilitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Makanan',
          ),
        ],
      ),
    );
  }
}
