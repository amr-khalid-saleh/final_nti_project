import 'package:flutter/material.dart';
import 'package:musix/features/profile/data/models/user_profile_model.dart';

class SubscriptionCardWidget extends StatelessWidget {
  final UserProfileModel profile;

  const SubscriptionCardWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final isPremium = profile.product == 'premium';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isPremium ? 'Musix Premium Plus' : 'Musix Free',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPremium 
                  ? 'Your plan is active. Enjoy lossless audio and offline playback.'
                  : 'Upgrade to Premium for ad-free listening, offline playback, and high-quality audio.',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE84818),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  isPremium ? 'Manage Subscription' : 'Upgrade to Premium',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}