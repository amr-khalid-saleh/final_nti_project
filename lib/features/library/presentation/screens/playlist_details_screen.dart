import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/shared_widgets/app_bottom_nav_bar.dart';
import '../../../../core/shared_widgets/app_mini_player.dart';

class PlaylistDetailsScreen extends StatelessWidget {
  const PlaylistDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E1E1E), AppColors.scaffoldBg],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleIcon(
                        Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      _circleIcon(Icons.more_horiz),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 150.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Playlist Card
                        Center(
                          child: Container(
                            width: 340.w,
                            height: 340.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24.r),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?auto=format&fit=crop&w=800&q=80',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24.r),
                                color: Colors.black.withValues(alpha: 0.3),
                              ),
                              child: Center(
                                child: Text(
                                  'AFTER HOURS ECHOES',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.font11GreyMedium
                                      .copyWith(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        letterSpacing: 2,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Title & Subtitle
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'After Hours Echoes',
                                style: AppTextStyles.font22WhiteBold.copyWith(
                                  fontSize: 24.sp,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Curated by Musix Editorial',
                                style: AppTextStyles.font14WhiteMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '48 songs • 2 hr 45 min',
                                style: AppTextStyles.font12GreyRegular,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Action Buttons
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Row(
                            children: [
                              // Play Button
                              Container(
                                width: 56.w,
                                height: 56.w,
                                decoration: const BoxDecoration(
                                  color: AppColors.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 32.sp,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              // Shuffle Button
                              _actionIcon(Icons.shuffle),
                              SizedBox(width: 16.w),
                              // Add Button
                              _actionIcon(Icons.add_circle_outline),
                            ],
                          ),
                        ),

                        SizedBox(height: 32.h),

                        // Tracks Header
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tracks',
                                style: AppTextStyles.font18WhiteSemiBold,
                              ),
                              Icon(
                                Icons.sort,
                                color: AppColors.textSecondary,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // Track List
                        ...List.generate(_sampleTracks.length, (index) {
                          final track = _sampleTracks[index];
                          return _trackTile(track);
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Mini Player
          Positioned(
            bottom: 100.h,
            left: 16.w,
            right: 16.w,
            child: const AppMiniPlayer(),
          ),

          // Bottom Nav Bar
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AppBottomNavBar(currentIndex: 2),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }

  Widget _actionIcon(IconData icon) {
    return Container(
      width: 56.w,
      height: 56.w,
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider),
      ),
      child: Icon(icon, color: Colors.white, size: 24.sp),
    );
  }

  Widget _trackTile(Map<String, String> track) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              image: DecorationImage(
                image: NetworkImage(track['image']!),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(track['title']!, style: AppTextStyles.font14WhiteMedium),
                SizedBox(height: 2.h),
                Text(track['artist']!, style: AppTextStyles.font12GreyRegular),
              ],
            ),
          ),
          Text(track['duration']!, style: AppTextStyles.font12GreyRegular),
        ],
      ),
    );
  }
}

const _sampleTracks = [
  {
    'title': 'Midnight City Lights',
    'artist': 'The Midnight Specter',
    'duration': '3:45',
    'image':
        'https://images.unsplash.com/photo-1514525253361-bee8a187c9bc?auto=format&fit=crop&w=100&q=80',
  },
  {
    'title': 'Velvet Horizon',
    'artist': 'Neon Dreams',
    'duration': '4:12',
    'image':
        'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=100&q=80',
  },
  {
    'title': 'Crimson Rain',
    'artist': 'Luna Shadows',
    'duration': '5:20',
    'image':
        'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?auto=format&fit=crop&w=100&q=80',
  },
  {
    'title': 'Slow Burn',
    'artist': 'The Jazz Collective',
    'duration': '3:58',
    'image':
        'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=100&q=80',
  },
];
