import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xmanah/views/login_page.dart';
import 'package:xmanah/views/profile.dart';
import 'package:xmanah/controller/desa.dart';
import 'package:xmanah/controller/fasilitas_kesehatan.dart';
import 'package:xmanah/controller/kost.dart';
import 'package:xmanah/controller/tempat_ibadah.dart';
import 'package:xmanah/controller/lembaga_pendidikan.dart';
import 'package:xmanah/controller/tempat_makan.dart';
import 'package:xmanah/widgets/searchpageresult.dart';
import 'dart:async';

class CustomNavbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _CustomNavbarState createState() => _CustomNavbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomNavbarState extends State<CustomNavbar> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  bool isLoggedIn = false;
  List<Map<String, dynamic>> _searchResults = [];
  final _debounce = Debouncer(milliseconds: 500);

  final DesaService _desaService = DesaService();
  final FasilitasKesehatanService _fasilitasKesehatanService = FasilitasKesehatanService();
  final KostService _kostService = KostService();
  final TempatIbadahService _tempatIbadahService = TempatIbadahService();
  final LembagaPendidikanService _lembagaPendidikanService = LembagaPendidikanService();
  final TempatMakanService _tempatMakanService = TempatMakanService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool loginStatus = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      isLoggedIn = loginStatus;
    });
  }

  void _searchDesa(String query) {
    _debounce.run(() {
      if (query.isNotEmpty) {
        _performSearch(query);
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  // Comprehensive search method
  Future<List<Map<String, dynamic>>> _searchAllData(String query) async {
    List<Map<String, dynamic>> allResults = [];

    // Search for desa first
    List<Map<String, dynamic>> desaResults = await _desaService.searchDesa(query);

    for (var desa in desaResults) {
      String desaId = desa['id'];
      
      // Fetch related data for the desa
      List<Map<String, dynamic>> kostResults = await _kostService.getKostListByDesa(desaId);
      List<Map<String, dynamic>> fasilitasResults = await _fasilitasKesehatanService.getFasilitasKesehatanListByDesa(desaId);
      List<Map<String, dynamic>> tempatIbadahResults = await _tempatIbadahService.getTempatIbadahListByDesa(desaId);
      List<Map<String, dynamic>> lembagaPendidikanResults = await _lembagaPendidikanService.getLembagaPendidikanByDesa(desaId);
      List<Map<String, dynamic>> tempatMakanResults = await _tempatMakanService.getTempatMakanListByDesa(desaId);

      allResults.addAll(kostResults);
      allResults.addAll(fasilitasResults);
      allResults.addAll(tempatIbadahResults);
      allResults.addAll(lembagaPendidikanResults);
      allResults.addAll(tempatMakanResults);
    }

    return allResults;
  }

  // Fungsi untuk melakukan pencarian
  Future<void> _performSearch(String query) async {
    try {
      List<Map<String, dynamic>> searchResults = await _searchAllData(query);

      if (searchResults.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsPage(results: searchResults),
          ),
        );
      } else {
        // Show a dialog or snackbar that no results were found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tidak ada hasil untuk "$query"')),
        );
      }
    } catch (e) {
      print("Error in search: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan dalam pencarian')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF334d2b),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/xmanah.png',
          height: 30,
          width: 30,
          fit: BoxFit.contain,
        ),
      ),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Desa, Fasilitas, Kost, dll.',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
              onChanged: _searchDesa,
              onSubmitted: (query) {
                _searchDesa(query);
              },
            )
          : null,
      actions: [
        if (!_isSearching)
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        if (_isSearching)
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
                _searchResults = [];
              });
            },
          ),
        IconButton(
          icon: Icon(Icons.person, color: Colors.black),
          onPressed: () {
            if (isLoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
        ),
      ],
    );
  }
}

// Debouncer class remains the same
class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}