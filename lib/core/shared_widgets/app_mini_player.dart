import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theming/app_text_styles.dart';
import '../theming/app_colors.dart';
import '../utils/app_routes.dart';
import '../../features/now_playing/controller/now_playing_cubit.dart';
import '../../features/now_playing/controller/now_playing_state.dart';

class AppMiniPlayer extends StatelessWidget {
  const AppMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        final cubit = context.read<NowPlayingCubit>();
        final loaded = state is NowPlayingLoaded ? state : NowPlayingLoaded();
        final track = loaded.currentTrack;

        // Hide mini player
        if (track == null) return const SizedBox.shrink();

        final imageUrl = track.album?.images.isNotEmpty == true
            ? track.album!.images.first.url
            : null;
        final artistName = track.artists.isNotEmpty
            ? track.artists.first.name
            : 'Unknown Artist';

        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.nowPlaying),
          child: Container(
            height: 64.h,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.divider),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black45,
                    blurRadius: 10,
                    offset: Offset(0, 4)),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                // Album art
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.r),
                    color: AppColors.cardBg,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.music_note,
                              color: AppColors.accent,
                              size: 20),
                        )
                      : const Icon(Icons.music_note,
                          color: AppColors.accent, size: 20),
                ),
                SizedBox(width: 12.w),
                // Track info
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        track.name,
                        style: AppTextStyles.font14WhiteMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        artistName,
                        style: AppTextStyles.font11GreyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Favourite
                Icon(Icons.favorite_border, color: Colors.white, size: 24.sp),
                SizedBox(width: 16.w),
                // Play / Pause toggle
                GestureDetector(
                  onTap: cubit.togglePlay,
                  child: Icon(
                    loaded.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
