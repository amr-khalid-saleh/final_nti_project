import 'package:flutter/material.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool isPlaying = true;
  bool isShuffle = false;
  bool isRepeat = false;
  double progress = 0.45;

  @override
  Widget build(BuildContext context) {
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

                // Top Bar
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
                          Text('PLAYING FROM PLAYLIST',
                              style: AppTextStyles.font11GreyMedium),
                          const Text(
                            'Cyberpunk Echoes',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.more_vert,
                        color: AppColors.textPrimary, size: 22),
                  ],
                ),

                const SizedBox(height: 32),

                // Album Art
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
                  child: const Center(
                    child: Icon(Icons.music_note,
                        color: AppColors.accent, size: 80),
                  ),
                ),

                const SizedBox(height: 28),

                // Song Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Midnight Protocol', style: AppTextStyles.font22WhiteBold),
                        const SizedBox(height: 4),
                        Text('Synthetic Horizons', style: AppTextStyles.font12GreyRegular),
                      ],
                    ),
                    const Icon(Icons.favorite_border,
                        color: AppColors.textSecondary, size: 24),
                  ],
                ),

                const SizedBox(height: 20),

                // Progress Bar
                Slider(
                  value: progress,
                  onChanged: (v) => setState(() => progress = v),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('2:14', style: AppTextStyles.font12GreyRegular),
                      Text('4:58', style: AppTextStyles.font12GreyRegular),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(Icons.shuffle,
                          color: isShuffle
                              ? AppColors.accent
                              : AppColors.textSecondary,
                          size: 22),
                      onPressed: () => setState(() => isShuffle = !isShuffle),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_previous,
                          color: AppColors.textPrimary, size: 32),
                      onPressed: () {},
                    ),
                    GestureDetector(
                      onTap: () => setState(() => isPlaying = !isPlaying),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next,
                          color: AppColors.textPrimary, size: 32),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.repeat,
                          color: isRepeat
                              ? AppColors.accent
                              : AppColors.textSecondary,
                          size: 22),
                      onPressed: () => setState(() => isRepeat = !isRepeat),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Bottom Bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.speaker,
                            color: AppColors.textSecondary, size: 18),
                        const SizedBox(width: 6),
                        Text('Studio Speakers', style: AppTextStyles.font12GreyRegular),
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
  }
}
