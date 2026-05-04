import 'package:flutter/material.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class FreshFindCard extends StatelessWidget {
  final String title;
  final String genre;
  final VoidCallback onTap;

  const FreshFindCard({
    super.key,
    required this.title,
    required this.genre,
    required this.onTap, String? imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const Center(
                  child: Icon(Icons.album, color: AppColors.accent, size: 36),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.font14WhiteMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  Text(genre, style: AppTextStyles.font11GreyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
