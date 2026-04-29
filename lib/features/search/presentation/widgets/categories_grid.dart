import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final IconData icon;
  final Color? overlayColor;

  const CategoryCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.icon,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  overlayColor ?? Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Title
          Positioned(
            top: 16,
            left: 16,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          // Icon at bottom
          Positioned(
            bottom: 16,
            left: 16,
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}