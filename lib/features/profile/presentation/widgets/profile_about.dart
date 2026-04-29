import 'package:flutter/material.dart';
import 'profile_stat_item.dart';

class ProfileAbout extends StatelessWidget {
  final String bio;
  final String monthlyListeners;
  final String globalRank;

  const ProfileAbout({
    super.key,
    required this.bio,
    required this.monthlyListeners,
    required this.globalRank,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        bio,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFF5500),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.info_outline,
                        color: Color(0xFFFF5500),
                        size: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ProfileStatItem(
                      value: monthlyListeners,
                      label: 'Monthly\nListeners',
                    ),
                    const SizedBox(width: 10),
                    ProfileStatItem(
                      value: globalRank,
                      label: 'Rank\nGlobal',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}