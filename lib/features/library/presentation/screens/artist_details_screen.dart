import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/spotify_models.dart';
import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/player_utils.dart';
import '../widgets/primary_action_button.dart';

class ArtistDetailsScreen extends StatelessWidget {
  final ArtistModel? artist;

  const ArtistDetailsScreen({super.key, this.artist});

  @override
  Widget build(BuildContext context) {
    final name = artist?.name ?? 'Artist';
    final imageUrl = artist?.images.isNotEmpty == true
        ? artist!.images.first.url
        : null;
    final followers = artist?.followers;
    final genres = artist?.genres ?? [];
    final popularity = artist?.popularity;

    return MainScaffold(
      currentIndex: 2,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 200.h),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Color(0xFF140808), Color(0xFF240908)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Header ───────────────────────────────────────────
              SizedBox(
                height: 680.h,
                child: Stack(
                  children: [
                    // Background image
                    Positioned.fill(
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: AppColors.cardBg,
                                child: const Center(
                                  child: Icon(Icons.person,
                                      color: AppColors.accent, size: 120),
                                ),
                              ),
                            )
                          : Container(
                              color: AppColors.cardBg,
                              child: const Center(
                                child: Icon(Icons.person,
                                    color: AppColors.accent, size: 120),
                              ),
                            ),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.25),
                              Colors.black.withValues(alpha: 0.85),
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Top bar
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _circleIcon(context, Icons.arrow_back_ios_new),
                            Text(
                              'Musix',
                              style: AppTextStyles.font22WhiteBold
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                            _circleIcon(context, Icons.more_vert),
                          ],
                        ),
                      ),
                    ),
                    // Artist name + actions at bottom of hero
                    Positioned(
                      left: 24.w,
                      right: 24.w,
                      bottom: 36.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (artist != null)
                            Row(
                              children: [
                                Icon(Icons.verified,
                                    color: const Color(0xFFFF7A1A),
                                    size: 16.sp),
                                SizedBox(width: 6.w),
                                Text(
                                  'VERIFIED ARTIST',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 14.h),
                          Text(
                            name,
                            style: AppTextStyles.font28WhiteExtraBold
                                .copyWith(fontSize: 48.sp),
                          ),
                          SizedBox(height: 22.h),
                          Row(
                            children: [
                              const PrimaryActionButton(text: 'Play'),
                              SizedBox(width: 12.w),
                              const PrimaryActionButton(
                                text: 'Follow',
                                outlined: true,
                                width: 110,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Info Section ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),

                    // Genres
                    if (genres.isNotEmpty) ...[
                      Text('Genres',
                          style: TextStyle(
                              color: Colors.white, fontSize: 20.sp)),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: genres
                            .take(5)
                            .map((g) => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 14.w, vertical: 6.h),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardBg,
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: Text(g,
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13.sp)),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // About card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18.sp),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              if (followers != null)
                                _statBox(
                                    _formatFollowers(followers), 'Followers'),
                              if (followers != null) SizedBox(width: 14.w),
                              if (popularity != null)
                                _statBox('$popularity / 100', 'Popularity'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatFollowers(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return '$count';
  }

  Widget _statBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon) {
    return GestureDetector(
      onTap: icon == Icons.arrow_back_ios_new
          ? () => Navigator.pop(context)
          : null,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: Colors.white10,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white12),
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }
}