import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:xmanah/firstopen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isHovering = false;

  // Function to log out the user
  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => FirtsOpen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF334d2b),
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center( // Wrap dengan Center widget
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            width: double.infinity, // Tetap full width
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Tambahkan ini
           
              children: [
                // Profile Picture
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF738c5e),
                        Color(0xFF4d6b41),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 15,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(4),
                  child: ClipOval(
                    child: Container(
                      color: Colors.white,
                      child: user?.photoURL != null
                          ? Image.network(
                              user!.photoURL!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            )
                          : Icon(
                              Icons.person,
                              size: 100,
                              color: Color(0xFFc4d6b0),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 28),

                // User Info
                Card(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  color: Color(0xFF4d6b41),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                     
                      children: [
                        // Name
                        Row(
                          
                          children: [
                            Icon(Icons.person_outline, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              user?.displayName ?? 'Guest User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Divider(color: Colors.white38, thickness: 1, height: 24),

                        // Email
                        Row(
                         
                          children: [
                            Icon(Icons.email_outlined, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              user?.email ?? 'No email available',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        Divider(color: Colors.white38, thickness: 1, height: 24),

                        // Password
                        Row(
                        
                          children: [
                            Icon(Icons.lock_outline, color: Colors.white, size: 28),
                            SizedBox(width: 12),
                            Text(
                              '********',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Logout Button
                MouseRegion(
                  onEnter: (_) => setState(() => _isHovering = true),
                  onExit: (_) => setState(() => _isHovering = false),
                  child: AnimatedScale(
                    duration: Duration(milliseconds: 200),
                    scale: _isHovering ? 1.05 : 1.0,
                    child: ElevatedButton.icon(
                      onPressed: () => _logout(context),
                      icon: Icon(
                        Icons.logout,
                        color: Colors.white,
                        size: 22,
                      ),
                      label: Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF8e3b46),
                        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: _isHovering ? 10 : 5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color(0xFF334d2b),
    );
  }
}