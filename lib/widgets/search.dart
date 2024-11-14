import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final VoidCallback onCancel;

  SearchBar({required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Cari...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: onCancel,
        ),
      ],
    );
  }
}
