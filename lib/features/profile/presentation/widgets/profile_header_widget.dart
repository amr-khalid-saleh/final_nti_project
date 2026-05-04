import 'package:flutter/material.dart';
import 'package:musix/features/profile/data/models/user_profile_model.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserProfileModel profile;

  const ProfileHeaderWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final imageUrl = profile.images.isNotEmpty ? profile.images.first.url : null;
    final isPremium = profile.product == 'premium';

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
            image: imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: imageUrl == null
              ? ClipOval(
                  child: Container(
                    color: const Color(0xFF2A2A2A),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white54,
                      size: 50,
                    ),
                  ),
                )
              : null,
        ),

        const SizedBox(height: 12),

        Text(
          profile.displayName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: isPremium ? const Color(0xFF2A1500) : Colors.grey[800],
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isPremium ? const Color(0xFFE84818).withValues(alpha: 0.5) : Colors.grey,
            ),
          ),
          child: Text(
            isPremium ? 'PREMIUM MEMBER' : 'FREE ACCOUNT',
            style: TextStyle(
              color: isPremium ? const Color(0xFFE84818) : Colors.white70,
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

