import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xmanah/home.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart';
import 'package:xmanah/views/desa/edit_desa_page.dart';
import 'package:xmanah/views/desa/tambah_desa_page.dart';
import 'package:xmanah/views/desa/view_desa_page.dart';
import 'package:xmanah/views/fasilitas_kesehatan/tambah_fasilitas_kesehatan_page.dart';
import 'package:xmanah/views/fasilitas_kesehatan/view_fasilitas_kesehatan_page.dart';
import 'package:xmanah/views/kost/tambah_kost_page.dart';
import 'package:xmanah/views/kost/view_kost_page.dart';
import 'package:xmanah/views/lembaga_pendidikan/tambah_lembaga_pendidikan_page.dart';

import 'package:xmanah/views/tempat_ibadah/tambah_tempat_ibadah.dart';
import 'package:xmanah/views/tempat_makan/tambah_tempat_makan.dart';
import 'package:xmanah/widgets/navbar.dart';

import 'package:xmanah/views/lembaga_pendidikan/view_lembaga_pendidikan_page.dart';
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

      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DesaViewPage(),

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
