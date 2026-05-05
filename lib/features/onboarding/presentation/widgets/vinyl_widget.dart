
import 'package:flutter/material.dart';

class VinylWidget extends StatelessWidget {
  const VinylWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Image.asset(
        'assets/images/Border_OverlayBlur.png',
        width: 220,
        height: 220,
        fit: BoxFit.cover,
      ),
    );
  }
}
