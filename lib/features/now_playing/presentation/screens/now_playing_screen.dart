import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../controller/now_playing_cubit.dart';
import '../../controller/now_playing_state.dart';

class NowPlayingScreen extends StatelessWidget {
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NowPlayingCubit, NowPlayingState>(
      builder: (context, state) {
        final cubit = context.read<NowPlayingCubit>();
        final loaded = state is NowPlayingLoaded ? state : NowPlayingLoaded();
        final track = loaded.currentTrack;

        // Resolve display strings from the real TrackModel
        final trackName = track?.name ?? 'Nothing playing';
        final artistName = track?.artists.isNotEmpty == true
            ? track!.artists.first.name
            : 'Pick a song to start';
        final imageUrl = track?.album?.images.isNotEmpty == true
            ? track!.album!.images.first.url
            : null;
        final durationMs = track?.durationMs ?? 0;
        final progressMs = (loaded.progress * durationMs).toInt();
        final totalMin = (durationMs / 60000).floor();
        final totalSec = ((durationMs % 60000) / 1000)
            .floor()
            .toString()
            .padLeft(2, '0');
        final curMin = (progressMs / 60000).floor();
        final curSec = ((progressMs % 60000) / 1000)
            .floor()
            .toString()
            .padLeft(2, '0');

        return Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.scaffoldBgTop, AppColors.scaffoldBgBottom],
              stops: [0.6, 0.97],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // ── Top Bar ───────────────────────────────────────────
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.keyboard_arrow_down,
                              color: AppColors.textPrimary, size: 28),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text('NOW PLAYING',
                                  style: AppTextStyles.font11GreyMedium),
                              Text(
                                artistName,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.more_vert,
                            color: AppColors.textPrimary, size: 22),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // ── Album Art ─────────────────────────────────────────
                    Container(
                      width: double.infinity,
                      height: 280,
                      decoration: BoxDecoration(
                        color: AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 40,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Center(
                                child: Icon(Icons.music_note,
                                    color: AppColors.accent, size: 80),
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.music_note,
                                  color: AppColors.accent, size: 80),
                            ),
                    ),

                    const SizedBox(height: 28),

                    // ── Song Info ─────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(trackName,
                                  style: AppTextStyles.font22WhiteBold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(artistName,
                                  style: AppTextStyles.font12GreyRegular,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        const Icon(Icons.favorite_border,
                            color: AppColors.textSecondary, size: 24),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ── Progress Bar ──────────────────────────────────────
                    Slider(
                      value: loaded.progress,
                      onChanged: (v) => cubit.seekTo(v),
                      activeColor: AppColors.accent,
                      inactiveColor: AppColors.divider,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('$curMin:$curSec',
                              style: AppTextStyles.font12GreyRegular),
                          Text('$totalMin:$totalSec',
                              style: AppTextStyles.font12GreyRegular),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ── Controls ──────────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shuffle,
                              color: loaded.isShuffle
                                  ? AppColors.accent
                                  : AppColors.textSecondary,
                              size: 22),
                          onPressed: cubit.toggleShuffle,
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous,
                              color: AppColors.textPrimary, size: 32),
                          onPressed: cubit.skipPrevious,
                        ),
                        GestureDetector(
                          onTap: cubit.togglePlay,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              loaded.isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next,
                              color: AppColors.textPrimary, size: 32),
                          onPressed: cubit.skipNext,
                        ),
                        IconButton(
                          icon: Icon(Icons.repeat,
                              color: loaded.isRepeat
                                  ? AppColors.accent
                                  : AppColors.textSecondary,
                              size: 22),
                          onPressed: cubit.toggleRepeat,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // ── Bottom Bar ────────────────────────────────────────
                    // Shows SDK connection status and output device
                    if (!loaded.sdkConnected && track != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Colors.orange.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.info_outline,
                                color: Colors.orange, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Install & open Spotify app for in-app playback',
                                style: AppTextStyles.font12GreyRegular
                                    .copyWith(color: Colors.orange),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (loaded.sdkConnected)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.speaker,
                                  color: AppColors.accent, size: 18),
                              const SizedBox(width: 6),
                              Text('Spotify Connected',
                                  style: AppTextStyles.font12GreyRegular
                                      .copyWith(color: AppColors.accent)),
                            ],
                          ),
                          const Row(
                            children: [
                              Icon(Icons.share_outlined,
                                  color: AppColors.textSecondary, size: 20),
                              SizedBox(width: 16),
                              Icon(Icons.queue_music,
                                  color: AppColors.textSecondary, size: 20),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
