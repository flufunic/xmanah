import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TempatMakanDetail extends StatelessWidget {
  final String makanId;
  final String imageUrl;
  final String name;
  final String address;
  final String openingHours; // Jam buka dan tutup dalam format "08.00-17.00"

  const TempatMakanDetail({
    required this.makanId,
    required this.imageUrl,
    required this.name,
    required this.address,
    required this.openingHours,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color(0xFF334d2b), // Set background color to Color(0xFF334d2b)
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
            // Card untuk Gambar dan Data Tempat Makan
            Card(
              color: Color(0xFFF1F8E9), // Light green background for the card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6.0,
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gambar Tempat Makan
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 250,
                            color: Colors.grey[300],
                            child: Icon(Icons.image,
                                color: Colors.white, size: 50),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Tempat Makan
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8.0),

                        // Alamat dengan ikon
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Color(0xFF334d2b), size: 24),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                address,
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.grey[700]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),

                        // Jam Buka dan Jam Tutup dengan ikon
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                color: Color(0xFF334d2b), size: 24),
                            SizedBox(width: 8.0),
                            Text(
                              "Jam Buka: ",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              openingHours.split('-')[0], // Jam Buka
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),

                        Row(
                          children: [
                            Icon(Icons.access_time,
                                color: Color(0xFF334d2b), size: 24),
                            SizedBox(width: 8.0),
                            Text(
                              "Jam Tutup: ",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            Text(
                              openingHours.split('-')[1], // Jam Tutup
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.grey[800]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Integrated ComentTempata Makan Component
            ComentMakan(makanId: makanId),
          ],
        ),
      ),
    );
  }
}

// The existing ComentTempatMakan component remains the same as in the original code
class ComentMakan extends StatefulWidget {
  final String makanId;

  const ComentMakan({Key? key, required this.makanId}) : super(key: key);

  @override
  _ComentMakanState createState() => _ComentMakanState();
}

class _ComentMakanState extends State<ComentMakan> {
  double _averageRating = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateAverageRating();
  }

  void _calculateAverageRating() async {
    QuerySnapshot reviewsSnapshot = await FirebaseFirestore.instance
        .collection('tempat_makan')
        .doc(widget.makanId)
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
              "Rating ",
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Icon(Icons.star, color: Colors.amber, size: 24),
            SizedBox(width: 8.0),
            Text(
              _averageRating.toStringAsFixed(1),
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ],
        ),
        SizedBox(height: 16.0),

        // Review Form
        Card(
          color: Color(0xFFF1F8E9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6.0,
          margin: EdgeInsets.all(16.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _ReviewForm(makanId: widget.makanId),
          ),
        ),

        // Review List
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('tempat_makan')
              .doc(widget.makanId)
              .collection('reviews')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teks "Ulasan" yang muncul di atas ulasan
                Text(
                  'Ulasan:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                SizedBox(height: 8.0),

                // Kondisi untuk menampilkan jika tidak ada ulasan
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
                  Text(
                    'Belum ada ulasan',
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  // Jika ada ulasan, tampilkan daftar ulasan dalam Card
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var review = snapshot.data!.docs[index];
                      return Card(
                        color: Color(
                            0xFFF1F8E9), // Light green background for the card
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    review['userName'] ?? 'Anonymous',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.amber, size: 20),
                                      Text(
                                        review['rating'].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _ReviewForm extends StatefulWidget {
  final String makanId;

  const _ReviewForm({Key? key, required this.makanId}) : super(key: key);

  @override
  __ReviewFormState createState() => __ReviewFormState();
}

class __ReviewFormState extends State<_ReviewForm> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  void _submitReview() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      _showDialog(context, 'Anda harus login untuk memberikan ulasan.');
      return;
    }

    if (_reviewController.text.trim().isEmpty) {
      _showDialog(context, 'Ulasan tidak boleh kosong');
      return;
    }

    int? rating;
    try {
      rating = int.parse(_ratingController.text);
      if (rating < 1 || rating > 5) throw FormatException();
    } catch (e) {
      _showDialog(context, 'Masukkan rating antara 1-5');
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('tempat_makan')
          .doc(widget.makanId)
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

      _showDialog(context, 'Ulasan berhasil dikirim!');
    } catch (e) {
      _showDialog(context, 'Gagal mengirim ulasan. Silakan coba lagi.');
    }
  }

  void _showDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pemberitahuan'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
              backgroundColor: Color(0xFF334d2b)),
          child: Text('Kirim Ulasan', style: TextStyle(color: Colors.white)),
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
