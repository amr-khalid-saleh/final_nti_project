import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/models/spotify_models.dart';
import '../../cubit/library_cubit.dart';
import '../../cubit/library_state.dart';

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
            return const Center(
              child: CircularProgressIndicator(color: AppColors.textPrimary),
            );
          } else if (state is LibraryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message, style: AppTextStyles.font16WhiteSemiBold),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<LibraryCubit>().fetchLibraryData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is LibraryLoaded) {
            return Column(
              children: [
                // ── App Bar ────────────────────────────────────────────
                AppBar(
                  backgroundColor:
                      AppColors.scaffoldBg.withValues(alpha: 0.8),
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
                      Text('Your Library',
                          style: AppTextStyles.font22WhiteBold),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search,
                          color: AppColors.textPrimary),
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.search),
                    ),
                  ],
                ),

                // ── Tab Bar ────────────────────────────────────────────
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

                // ── Tab Views ──────────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _playlistsTab(state.playlists),
                      _artistsTab(state.artists),
                      _albumsTab(state.savedAlbums),
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

  // ── Playlists Tab ──────────────────────────────────────────────────────────
  Widget _playlistsTab(List<PlaylistModel> playlists) {
    if (playlists.isEmpty) {
      return _emptyState(
        title: 'No playlists yet',
        subtitle: 'Create or follow playlists to see them here.',
        icon: Icons.queue_music_outlined,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 200),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        final playlist = playlists[index];
        return _itemTile(
          imageUrl: playlist.images.isNotEmpty
              ? playlist.images.first.url
              : null,
          title: playlist.name,
          subtitle: 'Playlist · ${playlist.ownerName}',
          routeName: AppRoutes.playlistDetails,
          isCircle: false,
        );
      },
    );
  }

  // ── Artists Tab ────────────────────────────────────────────────────────────
  // Powered by /me/following?type=artist (fallback: /me/top/artists on 403)
  Widget _artistsTab(List<ArtistModel> artists) {
    if (artists.isEmpty) {
      return _emptyState(
        title: 'No artists found',
        subtitle: 'Follow artists or listen to more music to populate this tab.',
        icon: Icons.person_add_outlined,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 200),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return _itemTile(
          imageUrl: artist.images.isNotEmpty
              ? artist.images.first.url
              : null,
          title: artist.name,
          subtitle: 'Artist',
          routeName: AppRoutes.artistDetails,
          isCircle: true,
        );
      },
    );
  }

  // ── Albums Tab ─────────────────────────────────────────────────────────────
  Widget _albumsTab(List<AlbumModel> albums) {
    if (albums.isEmpty) {
      return _emptyState(
        title: 'No saved albums',
        subtitle: 'Save your favorite albums to listen later.',
        icon: Icons.album_outlined,
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 200),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        final album = albums[index];
        return _itemTile(
          imageUrl: album.images.isNotEmpty ? album.images.first.url : null,
          title: album.name,
          subtitle:
              'Album · ${album.artists?.isNotEmpty == true ? album.artists!.first.name : 'Unknown Artist'}',
          routeName: AppRoutes.albumDetails,
          isCircle: false,
        );
      },
    );
  }

  // ── Shared Tile ────────────────────────────────────────────────────────────
  Widget _itemTile({
    required String? imageUrl,
    required String title,
    required String subtitle,
    required String routeName,
    required bool isCircle,
  }) {
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
              // Thumbnail
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
                  borderRadius: isCircle ? null : BorderRadius.circular(8),
                  color: AppColors.cardBg,
                ),
                clipBehavior: Clip.antiAlias,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                          isCircle ? Icons.person : Icons.album,
                          color: AppColors.textSecondary,
                          size: 28,
                        ),
                      )
                    : Icon(
                        isCircle ? Icons.person : Icons.album,
                        color: AppColors.textSecondary,
                        size: 28,
                      ),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.font16WhiteMedium,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: AppTextStyles.font12GreyRegular,
                        overflow: TextOverflow.ellipsis),
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

  // ── Empty State ────────────────────────────────────────────────────────────
  Widget _emptyState({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 64,
                color: AppColors.textHint.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.font18WhiteSemiBold),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.font14WhiteMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.search),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Discover Music'),
            ),
          ],
        ),
      ),
    );
  }
}
