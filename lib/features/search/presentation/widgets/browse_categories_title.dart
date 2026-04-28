import 'package:flutter/material.dart';

class BrowseCategoriesTitle extends StatelessWidget {
  const BrowseCategoriesTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Browse Categories',
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}