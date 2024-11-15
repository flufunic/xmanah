import 'package:flutter/material.dart';
import 'package:xmanah/views/login_page.dart';

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
      backgroundColor: Colors.purple[200],
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
            // Navigate to LoginPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ],
    );
  }
}
