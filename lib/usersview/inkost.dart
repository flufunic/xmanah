import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class KostDetail extends StatelessWidget {
  final String kostId;
  final String imageUrl;
  final String name;
  final String address;
  final String kontak;
  final int harga;
  final String fasilitas;

  const KostDetail({
    required this.kostId,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.kontak,
    required this.harga,
    required this.fasilitas,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Kost
            imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, color: Colors.white, size: 50),
                  ),
            
            // Informasi Kost
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    address,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Fasilitas",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    fasilitas,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[800]),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    "Kontak: $kontak",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  
                  // Integrated ComentKost Component
                  ComentKost(kostId: kostId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// The existing ComentKost component remains the same as in the original code
class ComentKost extends StatefulWidget {
  final String kostId;

  const ComentKost({Key? key, required this.kostId}) : super(key: key);

  @override
  _ComentKostState createState() => _ComentKostState();
}

class _ComentKostState extends State<ComentKost> {
  // Variabel untuk menghitung rata-rata rating
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateAverageRating();
  }

  // Fungsi untuk menghitung rata-rata rating
  void _calculateAverageRating() async {
    QuerySnapshot reviewsSnapshot = await FirebaseFirestore.instance
        .collection('kost')
        .doc(widget.kostId)
        .collection('reviews')
        .get();

    if (reviewsSnapshot.docs.isNotEmpty) {
      double totalRating = 0.0;
      for (var doc in reviewsSnapshot.docs) {
        totalRating += doc['rating'];
      }
      setState(() {
        _averageRating = totalRating / reviewsSnapshot.docs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Rating
        Row(
          children: [
            Text(
              "Rating",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8.0),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber, size: 24),
                Text(
                  _averageRating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Review Form
        SizedBox(height: 16.0),
        _ReviewForm(kostId: widget.kostId),

        // Review List
        SizedBox(height: 16.0),
        Text(
          "Ulasan",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        _ReviewList(kostId: widget.kostId),
      ],
    );
  }
}

class _ReviewForm extends StatefulWidget {
  final String kostId;

  const _ReviewForm({Key? key, required this.kostId}) : super(key: key);

  @override
  __ReviewFormState createState() => __ReviewFormState();
}

class __ReviewFormState extends State<_ReviewForm> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  void _submitReview() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Anda harus login untuk memberikan ulasan.')),
      );
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ulasan tidak boleh kosong')),
      );
      return;
    }

    int? rating;
    try {
      rating = int.parse(_ratingController.text);
      if (rating < 1 || rating > 5) throw FormatException();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan rating antara 1-5')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance
        .collection('kost')
        .doc(widget.kostId)
        .collection('reviews')
        .add({
          'userId': currentUser.uid,
          'userName': currentUser.displayName ?? 'Anonymous',
          'userEmail': currentUser.email,
          'review': _reviewController.text.trim(),
          'rating': rating,
          'timestamp': FieldValue.serverTimestamp(),
        });

      _reviewController.clear();
      _ratingController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ulasan berhasil dikirim!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim ulasan. Silakan coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _ratingController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Rating (1-5)',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8.0),
        TextField(
          controller: _reviewController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Tulis ulasan Anda...',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 8.0),
        ElevatedButton(
          onPressed: _submitReview,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
          ),
          child: Text('Kirim Ulasan'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _reviewController.dispose();
    _ratingController.dispose();
    super.dispose();
  }
}

class _ReviewList extends StatelessWidget {
  final String kostId;

  const _ReviewList({Key? key, required this.kostId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('kost')
          .doc(kostId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text(
            'Belum ada ulasan',
            style: TextStyle(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          );
        }

        var reviews = snapshot.data!.docs;
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            var review = reviews[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review['userName'] ?? 'Anonymous',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 20),
                            Text(
                              review['rating'].toString(),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      review['review'],
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
