import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xmanah/views/login_page.dart';
import 'package:xmanah/views/profile.dart'; // Tambahkan import halaman profil Anda

class CustomNavbar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _CustomNavbarState createState() => _CustomNavbarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight); // Height of AppBar
}

class _CustomNavbarState extends State<CustomNavbar> {
  bool _isSearching = false; // Track search state
  TextEditingController _searchController = TextEditingController();
  bool isLoggedIn = false; // Track login status

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status when widget is initialized
  }

  // Function to check login status
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool loginStatus = prefs.getBool('isLoggedIn') ?? false;
    print('Login status: $loginStatus'); // Tambahkan log untuk debugging
    setState(() {
      isLoggedIn = loginStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF334d2b),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0), // Adjust padding as needed
        child: Image.asset(
          'assets/images/xmanah.png',
          height: 30, // Set the height of the image
          width: 30, // Set the width of the image
          fit: BoxFit.contain, // Ensure the image is not cropped
        ),
      ),
      title: _isSearching
          ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.white),
              ),
              style: TextStyle(color: Colors.white),
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
        IconButton(
          icon: Icon(Icons.person, color: Colors.black), // User icon
          onPressed: () {
            if (isLoggedIn) {
              // Navigate to ProfilePage if logged in
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            } else {
              // Navigate to LoginPage if not logged in
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
