import 'package:flutter/material.dart';

class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Musix',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.white.withOpacity(0.6),
            size: 20,
          ),
        ),
      ],
    );
  }
}