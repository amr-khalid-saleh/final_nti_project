import 'package:flutter/material.dart';

class MoodGridWidget extends StatelessWidget {
  const MoodGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: _MoodCard(
                    title: 'LATE NIGHT',
                    color: const Color(0xFF1A1A2E),
                    icon: Icons.nights_stay,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 3,
                  child: _MoodCard(
                    title: 'Jazz Focus',
                    imagePath: 'assets/images/Trumpet.png',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: _MoodCard(
                    title: 'Power Mix',
                    imagePath: 'assets/images/runner_man.png',
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: _MoodCard(
                    title: 'DAILY FRESH',
                    color: const Color(0xFF0D1A0D),
                    icon: Icons.wb_sunny_outlined,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoodCard extends StatelessWidget {
  final String title;
  final Color? color;
  final IconData? icon;
  final String? imagePath;

  const _MoodCard({
    required this.title,
    this.color,
    this.icon,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (imagePath != null)
            Image.asset(imagePath!, fit: BoxFit.cover)
          else
            Container(color: color ?? Colors.black),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
              ),
            ),
          ),

          if (icon != null)
            Center(
              child: Icon(
                icon,
                color: Colors.white.withOpacity(0.3),
                size: 40,
              ),
            ),

          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
