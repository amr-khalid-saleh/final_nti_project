import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/spotify_models.dart';
import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/player_utils.dart';
import '../widgets/primary_action_button.dart';

import '../../../../core/injection/injection_container.dart';
import '../../data/repositories/library_repository.dart';
import '../../../../core/utils/app_routes.dart';

class ArtistDetailsScreen extends StatefulWidget {
  final ArtistModel? artist;

  const ArtistDetailsScreen({super.key, this.artist});

  @override
  State<ArtistDetailsScreen> createState() => _ArtistDetailsScreenState();
}

class _ArtistDetailsScreenState extends State<ArtistDetailsScreen> {
  bool _loading = true;
  List<TrackModel> _topTracks = [];
  List<AlbumModel> _albums = [];

  @override
  void initState() {
    super.initState();
    _fetchArtistData();
  }

  Future<void> _fetchArtistData() async {
    if (widget.artist?.id == null || widget.artist!.id.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    
    final repo = sl<LibraryRepository>();
    final tracksFuture = repo.getArtistTopTracks(widget.artist!.id);
    final albumsFuture = repo.getArtistAlbums(widget.artist!.id);
    
    final results = await Future.wait([tracksFuture, albumsFuture]);
    
    if (mounted) {
      setState(() {
        _loading = false;
        results[0].fold((l) => null, (r) => _topTracks = r as List<TrackModel>);
        results[1].fold((l) => null, (r) => _albums = r as List<AlbumModel>);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.artist?.name ?? 'Artist';
    final imageUrl = widget.artist?.images.isNotEmpty == true
        ? widget.artist!.images.first.url
        : null;
    final followers = widget.artist?.followers;
    final genres = widget.artist?.genres ?? [];
    final popularity = widget.artist?.popularity;

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
                          if (widget.artist != null)
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
                    // Top Tracks
                    if (_loading)
                      const Center(
                          child: CircularProgressIndicator(color: AppColors.accent))
                    else if (_topTracks.isNotEmpty) ...[
                      Text('Top Tracks',
                          style: TextStyle(
                              color: Colors.white, fontSize: 20.sp)),
                      SizedBox(height: 12.h),
                      ..._topTracks.asMap().entries.map((entry) {
                        final idx = entry.key;
                        final track = entry.value;
                        final durationStr =
                            '${(track.durationMs / 60000).floor()}:${((track.durationMs % 60000) / 1000).floor().toString().padLeft(2, '0')}';
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
                                  child: Text('${idx + 1}',
                                      style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 14.sp)),
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
                                            fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.play_circle_outline, color: AppColors.accent, size: 18),
                                SizedBox(width: 8.w),
                                Text(durationStr,
                                    style: TextStyle(
                                        color: Colors.white54,
                                        fontSize: 12.sp)),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 30.h),
                    ],

                    // Albums
                    if (_albums.isNotEmpty) ...[
                      Text('Albums',
                          style: TextStyle(
                              color: Colors.white, fontSize: 20.sp)),
                      SizedBox(height: 12.h),
                      SizedBox(
                        height: 200.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _albums.length,
                          itemBuilder: (context, index) {
                            final album = _albums[index];
                            final imgUrl = album.images.isNotEmpty
                                ? album.images.first.url
                                : null;
                            return GestureDetector(
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.albumDetails,
                                arguments: album,
                              ),
                              child: Container(
                                width: 140.w,
                                margin: EdgeInsets.only(right: 16.w),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 140.w,
                                      height: 140.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(16.r),
                                        color: AppColors.cardBg,
                                        image: imgUrl != null
                                            ? DecorationImage(
                                                image: NetworkImage(imgUrl),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                      child: imgUrl == null
                                          ? const Icon(Icons.album,
                                              color: Colors.white24,
                                              size: 40)
                                          : null,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      album.name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (album.releaseDate != null)
                                      Text(
                                        album.releaseDate!.split('-')[0],
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12.sp),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
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