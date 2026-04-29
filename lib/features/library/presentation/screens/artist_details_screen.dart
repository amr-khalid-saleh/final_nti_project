import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../data/library_data.dart';
import '../widgets/album_card.dart';
import '../widgets/primary_action_button.dart';
import '../widgets/start_info_card.dart';
import '../widgets/track_tile.dart';

class ArtistDetailsScreen extends StatelessWidget {
  const ArtistDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Color(0xFF140808),
                Color(0xFF240908),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 720.h,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=1200&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.15),
                              Colors.black.withValues(alpha: 0.25),
                              Colors.black.withValues(alpha: 0.85),
                              Colors.black,
                            ],
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: Colors.white10,
                              backgroundImage: const NetworkImage(
                                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
                              ),
                            ),
                            Text(
                              'Musix',
                              style: AppTextStyles.font22WhiteBold.copyWith(fontStyle: FontStyle.italic),
                            ),
                            Container(
                              width: 42.w,
                              height: 42.w,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Icon(Icons.search, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24.w,
                      right: 24.w,
                      bottom: 36.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.verified, color: const Color(0xFFFF7A1A), size: 16.sp),
                              SizedBox(width: 6.w),
                              Text(
                                LibraryData.verifiedLabel,
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
                            LibraryData.artistName,
                            style: AppTextStyles.font28WhiteExtraBold.copyWith(fontSize: 54.sp),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Popular Tracks',
                          style: TextStyle(color: Colors.white, fontSize: 24.sp),
                        ),
                        Text(
                          'See all',
                          style: TextStyle(color: Colors.white38, fontSize: 18.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    ...LibraryData.popularTracks.map(
                          (track) => TrackTile(
                        index: track['index']!,
                        title: track['title']!,
                        artist: '',
                        subtitle: track['subtitle']!,
                        duration: '',
                        showImage: true,
                        imageUrl: track['image']!,
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Albums',
                          style: TextStyle(color: Colors.white, fontSize: 24.sp),
                        ),
                        Text(
                          'View all',
                          style: TextStyle(color: Colors.white38, fontSize: 18.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: LibraryData.albums
                            .map(
                              (album) => Padding(
                            padding: EdgeInsets.only(right: 14.w),
                            child: AlbumCard(
                              title: album['title']!,
                              subtitle: album['subtitle']!,
                              image: album['image']!,
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'About',
                      style: TextStyle(color: Colors.white, fontSize: 24.sp),
                    ),
                    SizedBox(height: 18.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF141414),
                        borderRadius: BorderRadius.circular(28.r),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 42.w,
                              height: 42.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF8A4A18),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.info_outline,
                                color: const Color(0xFF8A4A18),
                                size: 24.sp,
                              ),
                            ),
                          ),
                          Text(
                            LibraryData.aboutArtist,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.sp,
                              height: 1.7,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              const StatInfoCard(
                                value: '4.2M',
                                label: 'Monthly\nListeners',
                              ),
                              SizedBox(width: 14.w),
                              const StatInfoCard(
                                value: '128',
                                label: 'Rank\nGlobal',
                              ),
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
}