import 'package:flutter/material.dart';
import 'package:xmanah/main.dart';

class FirtsOpen extends StatefulWidget {
  @override
  _FirtsOpenState createState() => _FirtsOpenState();
}

class _FirtsOpenState extends State<FirtsOpen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _dotsAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi titik tiga
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Durasi animasi
    )..repeat();

    _dotsAnimation = IntTween(begin: 0, end: 3).animate(_controller);

    // Navigasi ke halaman utama
    _navigateToHome();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToHome() async {
    await Future.delayed(Duration(seconds: 5));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavBarExample()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200], // Latar belakang ungu
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo yang lebih besar
            Image.asset(
              'assets/images/xmanah.png',
              height: 150, // Ukuran logo
            ),
            // Kurangi jarak antara logo dan animasi titik tiga
            SizedBox(height: 2), // Jarak lebih kecil
            // Loading animasi titik tiga
            AnimatedBuilder(
              animation: _dotsAnimation,
              builder: (context, child) {
                String dots = '.' * _dotsAnimation.value;
                return Text(
                  '$dots',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white, // Warna teks putih
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
