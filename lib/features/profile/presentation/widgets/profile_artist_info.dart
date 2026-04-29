import 'package:flutter/material.dart';

class ProfileArtistInfo extends StatelessWidget {
  final String artistName;
  final bool isVerified;

  const ProfileArtistInfo({
    super.key,
    required this.artistName,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isVerified)
            Row(
              children: [
                const Icon(
                  Icons.verified,
                  color: Color(0xFFFF5500),
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  'VERIFIED ARTIST',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          const SizedBox(height: 6),
          Text(
            artistName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}