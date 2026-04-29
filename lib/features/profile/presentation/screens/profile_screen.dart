import 'package:flutter/material.dart';
import '../widgets/profile_artist_info.dart';
import '../widgets/profile_hero_image.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeroImage(
                imageUrl: 'assets/artist.png',
              ),
              ProfileArtistInfo(
                artistName: 'Julian Vane',
                isVerified: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}