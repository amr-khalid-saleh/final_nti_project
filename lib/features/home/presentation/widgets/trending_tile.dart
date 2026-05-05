import 'package:flutter/material.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class TrendingTile extends StatelessWidget {
  final String title;
  final String artist;
  final String duration;
  final String? imageUrl;
  final VoidCallback onTap;

  const TrendingTile({
    super.key,
    required this.title,
    required this.artist,
    required this.duration,
    required this.onTap,
    this.imageUrl,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      width: 44,
                      height: 44,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _fallbackBox(),
                    )
                  : _fallbackBox(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.font14WhiteMedium,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(artist, style: AppTextStyles.font12GreyRegular,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Text(duration, style: AppTextStyles.font12GreyRegular),
            const SizedBox(width: 8),
            const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _fallbackBox() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.music_note, color: AppColors.accent, size: 22),
    );
  }
}
