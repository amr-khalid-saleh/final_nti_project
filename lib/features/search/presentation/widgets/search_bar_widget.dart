import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final Function(String)? onSubmitted;

  const SearchBarWidget({super.key, this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        onSubmitted: onSubmitted,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Artists, songs, or podcasts',
          hintStyle: TextStyle(
            color: Colors.white54,
            fontSize: 16,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.white54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}