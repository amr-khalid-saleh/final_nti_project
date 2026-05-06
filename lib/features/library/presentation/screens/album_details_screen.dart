import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/injection/injection_container.dart';
import '../../../../core/models/spotify_models.dart';
import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/player_utils.dart';
import '../../data/repositories/library_repository.dart';
import '../widgets/primary_action_button.dart';

class AlbumDetailsScreen extends StatefulWidget {
  final AlbumModel? album;

  const AlbumDetailsScreen({super.key, this.album});

  @override
  State<AlbumDetailsScreen> createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen> {
  late AlbumModel _album;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _album = widget.album ?? AlbumModel(id: '', name: '', images: []);
    _loadFullAlbum();
  }

  Future<void> _loadFullAlbum() async {
    if (_album.id.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    // If already has tracks, skip the full fetch
    if (_album.tracks.isNotEmpty) {
      setState(() => _loading = false);
      return;
    }
    final result = await sl<LibraryRepository>().getAlbumById(_album.id);
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _loading = false;
      }),
      (full) => setState(() {
        _album = full;
        _loading = false;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _album.name.isNotEmpty ? _album.name : 'Album';
    final artistName = _album.artists?.isNotEmpty == true
        ? _album.artists!.first.name
        : 'Unknown Artist';
    final imageUrl =
        _album.images.isNotEmpty ? _album.images.first.url : null;
    final tracks = _album.tracks;

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
                  padding: EdgeInsets.symmetric(
                      horizontal: 24.w, vertical: 12.h),
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
                    width: 280.w,
                    height: 280.w,
                    margin: EdgeInsets.symmetric(horizontal: 24.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: AppColors.cardBg,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.25),
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

                // ── Info ───────────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.font22WhiteBold
                            .copyWith(fontSize: 24.sp),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        artistName,
                        style: AppTextStyles.font14WhiteMedium
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      if (_album.releaseDate != null) ...[
                        SizedBox(height: 4.h),
                        Text(
                          _album.releaseDate!,
                          style: AppTextStyles.font12GreyRegular,
                        ),
                      ],
                      SizedBox(height: 20.h),

                      // ── Play button ────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryActionButton(
                              text: 'PLAY ALBUM',
                              icon: Icons.play_arrow,
                              onTap: tracks.isNotEmpty
                                  ? () => playTrackAndNavigate(
                                      context, tracks.first)
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
                            style: TextStyle(
                                color: Colors.white38, fontSize: 16.sp),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Loading / Error / Empty / List
                      if (_loading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                                color: AppColors.accent),
                          ),
                        )
                      else if (_error != null)
                        _emptyState('Could not load tracks', _error!)
                      else if (tracks.isEmpty)
                        _emptyState(
                            'No tracks found',
                            'This album has no tracks available in your region.')
                      else
                        ...tracks.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final track = entry.value;
                          final artistStr = track.artists.isNotEmpty
                              ? track.artists.first.name
                              : artistName;
                          final minutes =
                              (track.durationMs / 60000).floor();
                          final seconds =
                              ((track.durationMs % 60000) / 1000)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');
                          final hasPreview =
                              track.previewUrl != null;

                          return InkWell(
                            onTap: () =>
                                playTrackAndNavigate(context, track),
                            borderRadius: BorderRadius.circular(12.r),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8.h),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14.w, vertical: 12.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF141414),
                                borderRadius:
                                    BorderRadius.circular(12.r),
                                border:
                                    Border.all(color: Colors.white10),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 28.w,
                                    child: Text(
                                      '${idx + 1}',
                                      style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          track.name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          artistStr,
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 12.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Preview availability indicator
                                  Icon(
                                    hasPreview
                                        ? Icons.play_circle_outline
                                        : Icons.play_disabled,
                                    color: hasPreview
                                        ? AppColors.accent
                                        : Colors.white24,
                                    size: 18,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    '$minutes:$seconds',
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12.sp),
                                  ),
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

  Widget _emptyState(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.music_off,
                color: AppColors.textHint, size: 48),
            const SizedBox(height: 12),
            Text(title,
                style: AppTextStyles.font14WhiteMedium
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                subtitle,
                style: AppTextStyles.font12GreyRegular,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
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