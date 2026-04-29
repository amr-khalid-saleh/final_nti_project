import 'package:flutter/material.dart';
import 'profile_album_item.dart';

class ProfileAlbums extends StatelessWidget {
  const ProfileAlbums({super.key});

  @override
  Widget build(BuildContext context) {
    final albums = [
      {
        'title': 'Neon Nights',
        'year': '2023',
        'image': 'https://picsum.photos/150/150?random=4',
      },
      {
        'title': 'Echo Chamber',
        'year': '2022',
        'image': 'https://picsum.photos/150/150?random=5',
      },
      {
        'title': 'Dark Matter',
        'year': '2021',
        'image': 'https://picsum.photos/150/150?random=6',
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
                'Albums',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'View all',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: albums.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) => ProfileAlbumItem(
              title: albums[index]['title']!,
              year: albums[index]['year']!,
              imageUrl: albums[index]['image']!,
            ),
          ),
        ),
      ],
    );
  }
}