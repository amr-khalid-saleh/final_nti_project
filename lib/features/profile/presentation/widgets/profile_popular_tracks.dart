import 'package:flutter/material.dart';
import 'profile_track_item.dart';

class ProfilePopularTracks extends StatelessWidget {
  const ProfilePopularTracks({super.key});

  @override
  Widget build(BuildContext context) {
    final tracks = [
      {
        'title': 'Electric Dreams',
        'plays': '32,405,102 plays',
        'image': 'https://picsum.photos/44/44?random=1',
      },
      {
        'title': 'Midnight Pulse',
        'plays': '28,910,004 plays',
        'image': 'https://picsum.photos/44/44?random=2',
      },
      {
        'title': 'Concrete Jungle',
        'plays': '15,220,991 plays',
        'image': 'https://picsum.photos/44/44?random=3',
      },
    ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Popular Tracks',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'See all',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        ...tracks.asMap().entries.map(
              (e) => ProfileTrackItem(
            index: e.key + 1,
            title: e.value['title']!,
            plays: e.value['plays']!,
            imageUrl: e.value['image']!,
          ),
        ),
      ],
    );
  }
}