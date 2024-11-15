import 'package:flutter/material.dart';

class PlaceCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String distance;
  final double rating;
  final String? discount;

  const PlaceCard({
    required this.title,
    required this.imageUrl,
    required this.distance,
    required this.rating,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              if (discount != null)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    color: Colors.red,
                    child: Text(
                      discount!,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            distance,
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
          Row(
            children: [
              Icon(Icons.star, size: 14, color: Colors.amber),
              SizedBox(width: 4),
              Text(
                rating.toString(),
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
