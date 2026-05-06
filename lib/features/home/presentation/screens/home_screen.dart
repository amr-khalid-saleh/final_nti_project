import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/player_utils.dart';
import '../../cubit/home_cubit.dart';
import '../../cubit/home_state.dart';
import '../widgets/fresh_find_card.dart';
import '../widgets/special_deal_card.dart';
import '../widgets/speed_dial_card.dart';
import '../widgets/trending_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 0,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.scaffoldBgTop, AppColors.scaffoldBgBottom],
            stops: [0.0, 0.97],
          ),
        ),
        child: SafeArea(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.textPrimary),
                );
              } else if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message, style: AppTextStyles.font16WhiteSemiBold),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<HomeCubit>().fetchHomeData(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              } else if (state is HomeLoaded) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      // ── App Bar ───────────────────────────────────────────
                      Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.cardBg,
                              border: Border.all(color: AppColors.divider),
                            ),
                            child: const Icon(Icons.person,
                                color: AppColors.textSecondary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('EVENING', style: AppTextStyles.font11GreyMedium),
                              Text('Welcome back', style: AppTextStyles.font22WhiteBold),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.search,
                                color: AppColors.textPrimary, size: 22),
                            onPressed: () =>
                                Navigator.pushNamed(context, AppRoutes.search),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Speed Dial (Recently Played) ──────────────────────
                      if (state.recentlyPlayed.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Speed Dial',
                                style: AppTextStyles.font18WhiteSemiBold),
                            Text('View History',
                                style: AppTextStyles.font13AccentSemiBold),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.recentlyPlayed.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final track = state.recentlyPlayed[index];
                              return SpeedDialCard(
                                title: track.name,
                                subtitle: track.artists.isNotEmpty
                                    ? track.artists.first.name
                                    : 'Unknown Artist',
                                imageUrl: track.album?.images.isNotEmpty == true
                                    ? track.album!.images.first.url
                                    : null,
                                onTap: () => playTrackAndNavigate(context, track),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // ── Special Deal (New Releases) ───────────────────────
                      // Mapped to GET /browse/new-releases (fallback: /search?q=tag:new)
                      // Spotify has no "trending albums" endpoint; new releases is
                      // the official album discovery source.
                      if (state.specialDealAlbums.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Special Deal',
                                style: AppTextStyles.font18WhiteSemiBold),
                            Text('See All',
                                style: AppTextStyles.font13AccentSemiBold),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 220,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.specialDealAlbums.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              final album = state.specialDealAlbums[index];
                              return SpecialDealCard(
                                title: album.name,
                                artist: album.artists?.isNotEmpty == true
                                    ? album.artists!.first.name
                                    : 'Unknown Artist',
                                imageUrl: album.images.isNotEmpty
                                    ? album.images.first.url
                                    : null,
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.albumDetails,
                                  arguments: album,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // ── Trending Now (Top Tracks) ─────────────────────────
                      // Mapped to GET /me/top/tracks
                      // Spotify has no "trending tracks" endpoint.
                      // Top tracks = user's most-listened = best personalized proxy.
                      if (state.topTracks.isNotEmpty) ...[
                        Text('Trending Now',
                            style: AppTextStyles.font18WhiteSemiBold),
                        const SizedBox(height: 12),
                        ...List.generate(state.topTracks.length, (index) {
                          final track = state.topTracks[index];
                          final minutes = (track.durationMs / 60000).floor();
                          final seconds =
                              ((track.durationMs % 60000) / 1000)
                                  .floor()
                                  .toString()
                                  .padLeft(2, '0');

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: TrendingTile(
                              title: track.name,
                              artist: track.artists.isNotEmpty
                                  ? track.artists.first.name
                                  : 'Unknown Artist',
                              duration: '$minutes:$seconds',
                              imageUrl: track.album?.images.isNotEmpty == true
                                  ? track.album!.images.first.url
                                  : null,
                              onTap: () => playTrackAndNavigate(context, track),
                            ),
                          );
                        }),
                        const SizedBox(height: 28),
                      ],

                      // ── Fresh Finds (User Playlists) ──────────────────────
                      if (state.featuredPlaylists.isNotEmpty) ...[
                        Text('Fresh Finds',
                            style: AppTextStyles.font18WhiteSemiBold),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.featuredPlaylists.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          itemBuilder: (context, index) {
                            final playlist = state.featuredPlaylists[index];
                            return FreshFindCard(
                              title: playlist.name,
                              genre: playlist.ownerName,
                              imageUrl: playlist.images.isNotEmpty
                                  ? playlist.images.first.url
                                  : null,
                              onTap: () => Navigator.pushNamed(
                                context,
                                AppRoutes.playlistDetails,
                                arguments: playlist,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
