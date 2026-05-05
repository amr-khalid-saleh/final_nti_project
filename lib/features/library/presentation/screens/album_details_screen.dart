import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/spotify_models.dart';
import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/player_utils.dart';
import '../widgets/primary_action_button.dart';

class AlbumDetailsScreen extends StatelessWidget {
  final AlbumModel? album;

  const AlbumDetailsScreen({super.key, this.album});

  @override
  Widget build(BuildContext context) {
    final name = album?.name ?? 'Album';
    final artistName = album?.artists?.isNotEmpty == true
        ? album!.artists!.first.name
        : 'Unknown Artist';
    final imageUrl = album?.images.isNotEmpty == true
        ? album!.images.first.url
        : null;
    final tracks = album?.tracks ?? [];

    return MainScaffold(
      currentIndex: 2,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF140606), Color(0xFF2B0906)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 200.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Bar ────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleIcon(context, Icons.arrow_back_ios_new),
                      _circleIcon(context, Icons.more_vert),
                    ],
                  ),
                ),

                // ── Album Art ──────────────────────────────────────────
                Center(
                  child: Container(
                    width: 300.w,
                    height: 300.w,
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: AppColors.cardBg,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.2),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: imageUrl != null
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(
                              child: Icon(Icons.album,
                                  color: AppColors.accent, size: 80),
                            ),
                          )
                        : const Center(
                            child: Icon(Icons.album,
                                color: AppColors.accent, size: 80),
                          ),
                  ),
                ),

                SizedBox(height: 24.h),

                // ── Album Info ─────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.font22WhiteBold
                            .copyWith(fontSize: 26.sp),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        artistName,
                        style: AppTextStyles.font14WhiteMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      if (album?.releaseDate != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          album!.releaseDate!,
                          style: AppTextStyles.font12GreyRegular,
                        ),
                      ],
                      SizedBox(height: 20.h),

                      // ── Action Row ──────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryActionButton(
                              text: 'PLAY ALBUM',
                              icon: Icons.play_arrow,
                              onTap: tracks.isNotEmpty
                                  ? () => playTrackAndNavigate(context, tracks.first)
                                  : null,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _smallAction(Icons.favorite_border),
                          SizedBox(width: 12.w),
                          _smallAction(Icons.file_download_outlined),
                        ],
                      ),
                      SizedBox(height: 28.h),

                      // ── Tracklist ──────────────────────────────────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tracklist',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 22.sp)),
                          Text(
                            '${tracks.length} tracks',
                            style:
                                TextStyle(color: Colors.white38, fontSize: 16.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      if (tracks.isEmpty)
                        _emptyTracks()
                      else
                        ...tracks.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final track = entry.value;
                          final artistStr = track.artists.isNotEmpty
                              ? track.artists.first.name
                              : artistName;
                          final minutes = (track.durationMs / 60000).floor();
                          final seconds = ((track.durationMs % 60000) / 1000)
                              .floor()
                              .toString()
                              .padLeft(2, '0');

                          return InkWell(
                            onTap: () => playTrackAndNavigate(context, track),
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF141414),
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 28.w,
                                    child: Text(
                                      '${idx + 1}',
                                      style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 15.sp),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(track.name,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                        SizedBox(height: 2.h),
                                        Text(artistStr,
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 13.sp),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ],
                                    ),
                                  ),
                                  Text('$minutes:$seconds',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13.sp)),
                                  SizedBox(width: 8.w),
                                  const Icon(Icons.more_vert,
                                      color: Colors.white38, size: 18),
                                ],
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _emptyTracks() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.music_off, color: AppColors.textHint, size: 48),
            const SizedBox(height: 12),
            Text('No tracks available',
                style: AppTextStyles.font14WhiteMedium
                    .copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon) {
    return GestureDetector(
      onTap: icon == Icons.arrow_back_ios_new ? () => Navigator.pop(context) : null,
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

  Widget _smallAction(IconData icon) {
    return Container(
      width: 56.w,
      height: 52.h,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Icon(icon, color: Colors.white, size: 22.sp),
    );
  }
}