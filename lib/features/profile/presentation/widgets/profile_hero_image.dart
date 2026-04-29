import 'package:flutter/material.dart';

class ProfileHeroImage extends StatelessWidget {
  final String imageUrl;

  const ProfileHeroImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 520,
      child: Image.asset(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}