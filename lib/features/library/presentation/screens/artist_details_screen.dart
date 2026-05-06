import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/models/spotify_models.dart';
import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/player_utils.dart';
import '../../cubit/artist_details_cubit.dart';
import '../../cubit/artist_details_state.dart';
import '../../data/library_data.dart';
import '../widgets/album_card.dart';
import '../widgets/primary_action_button.dart';
import '../widgets/start_info_card.dart';
import '../widgets/track_tile.dart';

class ArtistDetailsScreen extends StatelessWidget {
  final ArtistModel? artist;

  const ArtistDetailsScreen({super.key, this.artist});

  @override
  Widget build(BuildContext context) {
    if (artist == null) {
      return _ArtistDetailsContent(initialArtist: null);
    }

    return BlocBuilder<ArtistDetailsCubit, ArtistDetailsState>(
      builder: (context, state) {
        if (state is ArtistDetailsLoaded) {
          return _ArtistDetailsContent(
            initialArtist: artist,
            artistDetails: state.artist,
            topTracks: state.topTracks,
            albums: state.albums,
          );
        }

        if (state is ArtistDetailsError) {
          return _ArtistDetailsContent(
            initialArtist: state.initialArtist ?? artist,
            errorMessage: state.message,
            onRetry: () => context
                .read<ArtistDetailsCubit>()
                .fetchArtistDetails(state.initialArtist ?? artist!),
          );
        }

        return _ArtistDetailsContent(
          initialArtist: artist,
          isLoading: true,
        );
      },
    );
  }
}

class _ArtistDetailsContent extends StatelessWidget {
  final ArtistModel? initialArtist;
  final ArtistModel? artistDetails;
  final List<TrackModel> topTracks;
  final List<AlbumModel> albums;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const _ArtistDetailsContent({
    required this.initialArtist,
    this.artistDetails,
    this.topTracks = const [],
    this.albums = const [],
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final displayArtist = artistDetails ?? initialArtist;
    final artistName = displayArtist?.name.isNotEmpty == true
        ? displayArtist!.name
        : LibraryData.artistName;
    final artistImageUrl = displayArtist?.images.isNotEmpty == true
        ? displayArtist!.images.first.url
        : 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=1200&q=80';
    final aboutText = _buildAboutText(displayArtist);

    return MainScaffold(
      currentIndex: 2,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 200.h),
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
                        artistImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.black,
                          child: Icon(
                            Icons.person,
                            color: Colors.white24,
                            size: 120.sp,
                          ),
                        ),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 12.h,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _circleIcon(context, Icons.arrow_back_ios_new),
                            Text(
                              'Musix',
                              style: AppTextStyles.font22WhiteBold
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                            Container(
                              width: 42.w,
                              height: 42.w,
                              decoration: BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
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
                              Icon(
                                Icons.verified,
                                color: const Color(0xFFFF7A1A),
                                size: 16.sp,
                              ),
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
                            artistName,
                            style: AppTextStyles.font28WhiteExtraBold
                                .copyWith(fontSize: 54.sp),
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
                    if (isLoading) ...[
                      SizedBox(height: 20.h),
                      const _LoadingInfoCard(),
                      SizedBox(height: 28.h),
                    ],
                    if (errorMessage != null) ...[
                      SizedBox(height: 20.h),
                      _ErrorCard(
                        message: errorMessage!,
                        onRetry: onRetry,
                      ),
                      SizedBox(height: 28.h),
                    ],
                    _SectionHeader(
                      title: 'Popular Tracks',
                      actionText: 'See all',
                    ),
                    SizedBox(height: 18.h),
                    if (isLoading)
                      const _LoadingList(itemCount: 4)
                    else
                      ..._buildTrackTiles(context),
                    SizedBox(height: 28.h),
                    _SectionHeader(
                      title: 'Albums',
                      actionText: 'View all',
                    ),
                    SizedBox(height: 18.h),
                    if (isLoading) const _LoadingAlbumsRow() else _buildAlbumsList(),
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
                            aboutText,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18.sp,
                              height: 1.7,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              StatInfoCard(
                                value: _formatFollowers(
                                  displayArtist?.followers ?? 0,
                                ),
                                label: 'Spotify\nFollowers',
                              ),
                              SizedBox(width: 14.w),
                              StatInfoCard(
                                value: '${displayArtist?.popularity ?? 0}',
                                label: 'Popularity\nScore',
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

  List<Widget> _buildTrackTiles(BuildContext context) {
    if (topTracks.isEmpty) {
      return const [
        _EmptyStateCard(
          icon: Icons.music_off,
          title: 'No popular tracks found',
          subtitle: 'Spotify did not return top tracks for this artist yet.',
        ),
      ];
    }

    return topTracks.asMap().entries.map((entry) {
      final index = entry.key + 1;
      final track = entry.value;
      final imageUrl = track.album?.images.isNotEmpty == true
          ? track.album!.images.first.url
          : null;
      final artistName = track.artists.isNotEmpty
          ? track.artists.first.name
          : 'Unknown Artist';

      return TrackTile(
        index: '$index',
        title: track.name,
        artist: artistName,
        subtitle: artistName,
        duration: _formatDuration(track.durationMs),
        showImage: imageUrl != null,
        imageUrl: imageUrl,
        onTap: () => playTrackAndNavigate(context, track),
      );
    }).toList();
  }

  Widget _buildAlbumsList() {
    final displayedAlbums = albums
        .where((album) => album.images.isNotEmpty)
        .toList();

    if (displayedAlbums.isEmpty) {
      return const _EmptyStateCard(
        icon: Icons.album_outlined,
        title: 'No albums found',
        subtitle: 'Spotify did not return albums or singles for this artist yet.',
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: displayedAlbums.map((album) {
          final subtitle = album.artists?.isNotEmpty == true
              ? album.artists!.first.name
              : 'Album';

          return Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: AlbumCard(
              title: album.name,
              subtitle: subtitle,
              image: album.images.first.url,
            ),
          );
        }).toList(),
      ),
    );
  }

  String _buildAboutText(ArtistModel? artist) {
    if (artist == null || artist.genres.isEmpty) {
      return LibraryData.aboutArtist;
    }

    final genres = artist.genres.take(4).join(', ');
    return '${artist.name} is a Spotify artist known for $genres. '
        'This page is powered by Spotify artist details, top tracks, and albums.';
  }

  String _formatFollowers(int followers) {
    if (followers <= 0) return '—';
    if (followers >= 1000000) {
      return '${(followers / 1000000).toStringAsFixed(1)}M';
    }
    if (followers >= 1000) {
      return '${(followers / 1000).toStringAsFixed(1)}K';
    }
    return followers.toString();
  }

  String _formatDuration(int durationMs) {
    if (durationMs <= 0) return '';
    final totalSeconds = durationMs ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
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
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;

  const _SectionHeader({required this.title, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 24.sp),
        ),
        Text(
          actionText,
          style: TextStyle(color: Colors.white38, fontSize: 18.sp),
        ),
      ],
    );
  }
}


class _LoadingInfoCard extends StatelessWidget {
  const _LoadingInfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22.w,
            height: 22.w,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              'Loading artist details from Spotify...',
              style: AppTextStyles.font14WhiteMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyStateCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 46.w,
            height: 46.w,
            decoration: const BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white54, size: 24.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.font16WhiteSemiBold),
                SizedBox(height: 6.h),
                Text(subtitle, style: AppTextStyles.font12GreyRegular),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  final int itemCount;

  const _LoadingList({required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        itemCount,
        (_) => Padding(
          padding: EdgeInsets.only(bottom: 14.h),
          child: const _LoadingTile(),
        ),
      ),
    );
  }
}

class _LoadingTile extends StatelessWidget {
  const _LoadingTile();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LoadingBox(width: 54.w, height: 54.w, radius: 10.r),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LoadingBox(width: double.infinity, height: 14.h, radius: 8.r),
              SizedBox(height: 10.h),
              _LoadingBox(width: 160.w, height: 12.h, radius: 8.r),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingAlbumsRow extends StatelessWidget {
  const _LoadingAlbumsRow();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          3,
          (_) => Padding(
            padding: EdgeInsets.only(right: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LoadingBox(width: 140.w, height: 140.w, radius: 24.r),
                SizedBox(height: 12.h),
                _LoadingBox(width: 120.w, height: 12.h, radius: 8.r),
                SizedBox(height: 8.h),
                _LoadingBox(width: 80.w, height: 10.h, radius: 8.r),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _LoadingBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorCard({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1414),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: AppColors.accent,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Could not load full artist details',
                  style: AppTextStyles.font16WhiteSemiBold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            message,
            style: AppTextStyles.font12GreyRegular,
          ),
          if (onRetry != null) ...[
            SizedBox(height: 14.h),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
