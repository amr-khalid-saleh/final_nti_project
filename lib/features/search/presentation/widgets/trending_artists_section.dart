import 'dart:developer';

import 'package:flutter/material.dart';

class TrendingArtistsSection extends StatelessWidget {
  const TrendingArtistsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trending Artists',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Navigate to all artists
                log('See All tapped');
              },
              child: const Text(
                'SEE ALL',
                style: TextStyle(
                  color: Color(0xFFE84818),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Horizontal Scrolling Artists
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            itemBuilder: (context, index) {
              final artists = [
                {'name': 'Elias', 'image': 'assets/images/man.png'},
                {'name': 'Muna', 'image': 'assets/images/man.png'},
                {'name': 'Kael', 'image': 'assets/images/man.png'},
                {'name': 'Luna', 'image': 'assets/images/man.png'},
                {'name': 'Zed', 'image': 'assets/images/man.png'},
              ];

              final artist = artists[index % artists.length];

              return _ArtistCircle(
                name: artist['name']!,
                imagePath: artist['image']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ArtistCircle extends StatelessWidget {
  final String name;
  final String imagePath;

  const _ArtistCircle({
    required this.name,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 78,
          height: 78,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE84818),
              width: 3,
            ),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}