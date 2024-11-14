import 'package:flutter/material.dart';

class CustomNavbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _CustomNavbarState createState() => _CustomNavbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Height of AppBar
}

class _CustomNavbarState extends State<CustomNavbar> {
  bool _isSearching = false; // Track search state
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: Padding(
        padding:
            const EdgeInsets.all(8.0), // Sesuaikan padding sesuai kebutuhan
        child: Image.asset(
          'assets/images/x.png',
          height: 30, // Setel tinggi gambar
          width: 30, // Setel lebar gambar
          fit: BoxFit.contain, // Atur gambar agar tidak terpotong
        ),
      ),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: TextStyle(color: Colors.black),
            )
          : null, // Show search bar when searching
      actions: [
        if (!_isSearching)
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = true; // Enable search mode
              });
            },
          ),
        if (_isSearching)
          IconButton(
            icon: Icon(Icons.cancel, color: Colors.black),
            onPressed: () {
              setState(() {
                _isSearching = false; // Disable search mode
                _searchController.clear(); // Clear search text
              });
            },
          ),
      ],
    );
  }
}
