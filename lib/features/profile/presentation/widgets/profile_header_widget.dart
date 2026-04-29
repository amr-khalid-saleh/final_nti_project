import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE84818),
              width: 2.5,
            ),
          ),
          child: ClipOval(
            child: Container(
              color: const Color(0xFF2A2A2A),
              child: const Icon(
                Icons.person,
                color: Colors.white54,
                size: 50,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        const Text(
          'Alex Rivera',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF2A1500),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFFE84818).withValues(alpha: 0.5),
            ),
          ),
          child: const Text(
            'PREMIUM MEMBER',
            style: TextStyle(
              color: Color(0xFFE84818),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }
}
