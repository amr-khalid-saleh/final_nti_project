import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/models/spotify_models.dart';
import '../cubit/library_cubit.dart';
import '../cubit/library_state.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<LibraryCubit>().fetchLibraryData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      body: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          if (state is LibraryLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is LibraryError) {
             return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message, style: AppTextStyles.font16WhiteSemiBold),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<LibraryCubit>().fetchLibraryData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
          } else if (state is LibraryLoaded) {
            return Column(
              children: [
                AppBar(
                  backgroundColor: AppColors.scaffoldBg.withValues(alpha: 0.8),
                  elevation: 0,
                  title: Row(
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
                      const SizedBox(width: 12),
                      Text(
                        'Musix',
                        style: AppTextStyles.font22WhiteBold,
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search, color: AppColors.textPrimary),
                      onPressed: () {},
                    ),
                  ],
                ),
                Container(
                  color: AppColors.scaffoldBg,
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    controller: _tabController,
                    indicatorColor: AppColors.accent,
                    labelColor: AppColors.textPrimary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorWeight: 3,
                    tabAlignment: TabAlignment.center,
                    labelStyle: AppTextStyles.font18WhiteSemiBold,
                    unselectedLabelStyle: AppTextStyles.font18WhiteSemiBold,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Playlists'),
                      Tab(text: 'Artists'),
                      Tab(text: 'Albums'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _playlistsView(state.playlists, state.savedTracks),
                      _artistsView(state.followedArtists),
                      _albumsView(state.savedAlbums),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _playlistsView(List<PlaylistModel> playlists, List<TrackModel> savedTracks) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?auto=format&fit=crop&w=800&q=80'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8)
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: InkWell(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.playlistDetails),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.favorite,
                              color: AppColors.accent, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'Liked Songs',
                            style: AppTextStyles.font28WhiteExtraBold,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${savedTracks.length} tracks',
                            style: AppTextStyles.font14WhiteMedium
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.nowPlaying),
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45,
                              blurRadius: 10,
                              offset: Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              'YOUR PLAYLISTS',
              style: AppTextStyles.font11GreyMedium,
            ),
          ),
          ...List.generate(playlists.length, (index) {
            final playlist = playlists[index];
            return _itemTile(
              playlist.images.isNotEmpty ? playlist.images.first.url : 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=200&q=80',
              playlist.name,
              'Playlist · ${playlist.ownerName}',
              AppRoutes.playlistDetails,
            );
          }),
        ],
      ),
    );
  }

  Widget _artistsView(List<ArtistModel> artists) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('FOLLOWED ARTISTS', style: AppTextStyles.font11GreyMedium),
          ),
          if (artists.isEmpty)
             const Padding(
               padding: EdgeInsets.all(16.0),
               child: Text('No followed artists found.', style: TextStyle(color: Colors.grey)),
             ),
          ...List.generate(artists.length, (index) {
            final artist = artists[index];
            return _itemTile(
              'https://images.unsplash.com/photo-1520127873587-434cd6439b1e?auto=format&fit=crop&w=200&q=80', // Replace with artist image if model is updated
              artist.name,
              'Artist',
              AppRoutes.artistDetails,
            );
          }),
        ],
      ),
    );
  }

  Widget _albumsView(List<AlbumModel> albums) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('SAVED ALBUMS', style: AppTextStyles.font11GreyMedium),
          ),
          if (albums.isEmpty)
             const Padding(
               padding: EdgeInsets.all(16.0),
               child: Text('No saved albums found.', style: TextStyle(color: Colors.grey)),
             ),
          ...List.generate(albums.length, (index) {
            final album = albums[index];
            return _itemTile(
              album.images.isNotEmpty ? album.images.first.url : 'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?auto=format&fit=crop&w=200&q=80',
              album.name,
              'Album · ${album.artists?.isNotEmpty == true ? album.artists!.first.name : 'Unknown Artist'}',
              AppRoutes.albumDetails,
            );
          }),
        ],
      ),
    );
  }

  Widget _itemTile(
      String imageUrl, String title, String subtitle, String routeName) {
    bool isArtist = routeName == AppRoutes.artistDetails;
    return InkWell(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: isArtist ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: isArtist ? null : BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.font16WhiteMedium, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.font12GreyRegular, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const Icon(Icons.more_vert, color: AppColors.textHint),
            ],
          ),
        ),
      ),
    );
  }
}

