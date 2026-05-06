import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/spotify_models.dart';
import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/player_utils.dart';
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
    
    final bioText = genres.isNotEmpty 
        ? '$name is a visionary artist associated with ${genres.take(3).join(', ')}. Their sound blends cinematic atmospheric textures with hard-hitting rhythmic foundations, creating a unique sonic landscape that has captivated millions of listeners worldwide.'
        : '$name is an extraordinary artist whose sound blends cinematic atmospheric textures with hard-hitting rhythmic foundations, creating a unique sonic landscape that has captivated millions of listeners worldwide.';

    return MainScaffold(
      currentIndex: 2,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 200.h),
        child: Container(
          color: const Color(0xFF0F0606),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Header ───────────────────────────────────────────
              SizedBox(
                height: 520.h,
                child: Stack(
                  children: [
                    // Background image
                    Positioned.fill(
                      child: imageUrl != null
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: const Color(0xFF141414),
                              ),
                            )
                          : Container(color: const Color(0xFF141414)),
                    ),
                    // Gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.1),
                              Colors.black.withValues(alpha: 0.4),
                              const Color(0xFF0F0606).withValues(alpha: 0.9),
                              const Color(0xFF0F0606),
                            ],
                            stops: const [0.0, 0.4, 0.7, 0.9, 1.0],
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
                            _circleIcon(context, Icons.arrow_back, isBack: true),
                            Text(
                              'Musix',
                              style: AppTextStyles.font22WhiteBold
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                            _circleIcon(context, Icons.search),
                          ],
                        ),
                      ),
                    ),
                    // Artist name + actions at bottom of hero
                    Positioned(
                      left: 24.w,
                      right: 24.w,
                      bottom: 24.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.artist != null)
                            Row(
                              children: [
                                const Icon(Icons.verified,
                                    color: Color(0xFFFF4D00),
                                    size: 14),
                                SizedBox(width: 6.w),
                                Text(
                                  'VERIFIED ARTIST',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11.sp,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 8.h),
                          Text(
                            name,
                            style: AppTextStyles.font28WhiteExtraBold
                                .copyWith(fontSize: 42.sp, height: 1.1),
                          ),
                          SizedBox(height: 20.h),
                          Row(
                            children: [
                              _actionButton('Play', isPrimary: true),
                              SizedBox(width: 12.w),
                              _actionButton('Follow', isPrimary: false),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Main Content ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    // Popular Tracks
                    if (_loading)
                      const Center(
                          child: CircularProgressIndicator(color: Color(0xFFFF4D00)))
                    else if (_topTracks.isNotEmpty) ...[
                      _sectionHeader('Popular Tracks', 'See all'),
                      SizedBox(height: 16.h),
                      ..._topTracks.take(5).toList().asMap().entries.map((entry) {
                        final idx = entry.key;
                        final track = entry.value;
                        final durationStr =
                            '${(track.durationMs / 60000).floor()}:${((track.durationMs % 60000) / 1000).floor().toString().padLeft(2, '0')}';
                        final trackImageUrl = track.album?.images.isNotEmpty == true 
                            ? track.album!.images.first.url : null;
                            
                        return InkWell(
                          onTap: () => playTrackAndNavigate(context, track),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 12.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFF161010),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 20.w,
                                  child: Text('${idx + 1}',
                                      style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 14.sp)),
                                ),
                                SizedBox(width: 8.w),
                                // Track Artwork
                                Container(
                                  width: 44.w,
                                  height: 44.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.r),
                                    color: Colors.white10,
                                    image: trackImageUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(trackImageUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                  child: trackImageUrl == null
                                      ? const Icon(Icons.music_note, color: Colors.white24)
                                      : null,
                                ),
                                SizedBox(width: 14.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        track.name,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '$durationStr plays',
                                        style: TextStyle(
                                            color: Colors.white54,
                                            fontSize: 12.sp),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.more_vert, color: Colors.white38, size: 20),
                              ],
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 24.h),
                    ],

                    // Albums
                    if (_albums.isNotEmpty) ...[
                      _sectionHeader('Albums', 'View all'),
                      SizedBox(height: 16.h),
                      SizedBox(
                        height: 220.h,
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
                                        color: const Color(0xFF161010),
                                        image: imgUrl != null
                                            ? DecorationImage(
                                                image: NetworkImage(imgUrl),
                                                fit: BoxFit.cover,
                                              )
                                            : null,
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Text(
                                      album.name,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      '${album.releaseDate?.split('-')[0] ?? ''} • Album',
                                      style: TextStyle(
                                          color: Colors.white54,
                                          fontSize: 11.sp),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // About
                    _sectionHeader('About', ''),
                    SizedBox(height: 16.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161010),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  bioText,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13.sp,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Icon(Icons.info_outline, color: const Color(0xFFFF4D00), size: 24.sp),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              if (followers != null)
                                Expanded(child: _statBox(_formatFollowers(followers), 'Monthly\nListeners')),
                              if (followers != null && popularity != null) SizedBox(width: 12.w),
                              if (popularity != null)
                                Expanded(child: _statBox('$popularity', 'Rank\nGlobal')),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.w600)),
        if (actionText.isNotEmpty)
          Text(actionText, style: TextStyle(color: Colors.white54, fontSize: 13.sp)),
      ],
    );
  }

  Widget _actionButton(String text, {required bool isPrimary}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFFF4D00) : Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
        border: isPrimary ? null : Border.all(color: Colors.white24),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
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
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 6.h),
          Text(label,
              style: TextStyle(color: Colors.white54, fontSize: 12.sp, height: 1.2)),
        ],
      ),
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon, {bool isBack = false}) {
    return GestureDetector(
      onTap: isBack ? () => Navigator.pop(context) : null,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }
}