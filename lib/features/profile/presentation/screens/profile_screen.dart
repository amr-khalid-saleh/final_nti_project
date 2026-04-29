import 'package:flutter/material.dart';
import '../widgets/profile_about.dart';
import '../widgets/profile_action_buttons.dart';
import '../widgets/profile_albums.dart';
import '../widgets/profile_artist_info.dart';
import '../widgets/profile_hero_image.dart';
import '../widgets/profile_popular_tracks.dart';

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
              ProfileActionButtons(
                onPlay: () {},
                onFollow: () {},
              ),
              const SizedBox(height: 8),
              const ProfilePopularTracks(),
              const SizedBox(height: 8),
              const ProfileAlbums(),
              const SizedBox(height: 8),
              ProfileAbout(
                bio:
                'Julian Vane is an electronic visionary hailing from the underground scene of Berlin. His sound blends cinematic atmospheric textures with hard-hitting rhythmic foundations, creating a unique sonic landscape that has captivated millions of listeners worldwide.',
                monthlyListeners: '4.2M',
                globalRank: '128',
              ),
            ],
          ),
        ),
      ),
    );
  }
}