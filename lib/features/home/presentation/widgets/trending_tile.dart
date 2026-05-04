import 'package:flutter/material.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class TrendingTile extends StatelessWidget {
  final String title;
  final String artist;
  final String duration;
  final VoidCallback onTap;

  const TrendingTile({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
    required this.onTap, String? imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.thumb_up, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.font14WhiteMedium),
                  Text(artist, style: AppTextStyles.font12GreyRegular),
                ],
              ),
            ),
            Text(duration, style: AppTextStyles.font12GreyRegular),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert,
                color: AppColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }
}
