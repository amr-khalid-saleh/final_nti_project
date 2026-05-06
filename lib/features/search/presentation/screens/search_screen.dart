import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared_widgets/main_scaffold.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/player_utils.dart';
import '../../cubit/search_cubit.dart';
import '../../cubit/search_state.dart';
import '../widgets/browse_categories_title.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_bar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SearchCubit>().fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      body: SafeArea(
        child: BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.textPrimary),
              );
            } else if (state is SearchError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: AppTextStyles.font16WhiteSemiBold,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<SearchCubit>().fetchInitialData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (state is SearchInitialDataLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      const SearchAppBar(),
                      const SizedBox(height: 20),
                      // Pass callback to SearchBarWidget
                      SearchBarWidget(
                        onSubmitted: (query) {
                          context.read<SearchCubit>().searchItems(query);
                        },
                      ),
                      const SizedBox(height: 32),

                      const BrowseCategoriesTitle(),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.categories.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 1.05,
                            ),
                        itemBuilder: (context, index) {
                          final category = state.categories[index];
                          // Basic generic fallback icon if no image
                          final imageUrl = category.icons.isNotEmpty
                              ? category.icons.first.url
                              : null;
                          return Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(12),
                              image: imageUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.black.withValues(alpha: 0.4),
                                        BlendMode.darken,
                                      ),
                                    )
                                  : null,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              category.name,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.font16WhiteSemiBold,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Trending Artists Section
                      if (state.trendingArtists.isNotEmpty) ...[
                        Text(
                          'Trending Artists',
                          style: AppTextStyles.font18WhiteSemiBold,
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 120,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.trendingArtists.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final artist = state.trendingArtists[index];
                              final artistImage = artist.images.isNotEmpty
                                  ? artist.images.first.url
                                  : null;
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.artistDetails,
                                  arguments: artist,
                                ),
                                child: SizedBox(
                                  width: 90,
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 40,
                                        backgroundColor: AppColors.cardBg,
                                        backgroundImage: artistImage != null
                                            ? NetworkImage(artistImage)
                                            : null,
                                        child: artistImage == null
                                            ? const Icon(
                                                Icons.person,
                                                color: AppColors.textSecondary,
                                                size: 30,
                                              )
                                            : null,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        artist.name,
                                        style: AppTextStyles.font14WhiteMedium,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],

                      // Discover Section (Albums)
                      if (state.discoverAlbums.isNotEmpty) ...[
                        Text(
                          'Discover Albums',
                          style: AppTextStyles.font18WhiteSemiBold,
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.discoverAlbums.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final album = state.discoverAlbums[index];
                            final imageUrl = album.images.isNotEmpty
                                ? album.images.first.url
                                : null;
                            return Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColors.cardBg,
                                    image: imageUrl != null
                                        ? DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                          )
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        album.name,
                                        style:
                                            AppTextStyles.font16WhiteSemiBold,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        album.artists?.isNotEmpty == true
                                            ? album.artists!.first.name
                                            : 'Unknown Artist',
                                        style: AppTextStyles.font12GreyRegular,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                      ],
                    ],
                  ),
                ),
              );
            } else if (state is SearchResultsLoaded) {
              if (state.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      const SearchAppBar(),
                      const SizedBox(height: 20),
                      SearchBarWidget(
                        onSubmitted: (query) {
                          context.read<SearchCubit>().searchItems(query);
                        },
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.search_off,
                        color: AppColors.textSecondary,
                        size: 56,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: AppTextStyles.font18WhiteSemiBold,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try searching for another artist, track, or album.',
                        style: AppTextStyles.font12GreyRegular,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                    ],
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                children: [
                  const SearchAppBar(),
                  const SizedBox(height: 20),
                  SearchBarWidget(
                    onSubmitted: (query) {
                      context.read<SearchCubit>().searchItems(query);
                    },
                  ),
                  const SizedBox(height: 28),
                  if (state.artists.isNotEmpty) ...[
                    Text(
                      'Artists',
                      style: AppTextStyles.font18WhiteSemiBold,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 122,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.artists.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          final artist = state.artists[index];
                          final imageUrl = artist.images.isNotEmpty
                              ? artist.images.first.url
                              : null;

                          return GestureDetector(
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.artistDetails,
                              arguments: artist,
                            ),
                            child: SizedBox(
                              width: 90,
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 40,
                                    backgroundColor: AppColors.cardBg,
                                    backgroundImage: imageUrl != null
                                        ? NetworkImage(imageUrl)
                                        : null,
                                    child: imageUrl == null
                                        ? const Icon(
                                            Icons.person,
                                            color: AppColors.textSecondary,
                                            size: 30,
                                          )
                                        : null,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    artist.name,
                                    style: AppTextStyles.font14WhiteMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  if (state.tracks.isNotEmpty) ...[
                    Text(
                      'Tracks',
                      style: AppTextStyles.font18WhiteSemiBold,
                    ),
                    const SizedBox(height: 12),
                    ...state.tracks.map((track) {
                      final imageUrl = track.album?.images.isNotEmpty == true
                          ? track.album!.images.first.url
                          : null;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          onTap: () => playTrackAndNavigate(context, track),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: imageUrl != null
                                ? Image.network(
                                    imageUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 48,
                                      height: 48,
                                      color: AppColors.cardBg,
                                      child: const Icon(
                                        Icons.music_note,
                                        color: AppColors.accent,
                                        size: 20,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 48,
                                    height: 48,
                                    color: AppColors.cardBg,
                                    child: const Icon(
                                      Icons.music_note,
                                      color: AppColors.accent,
                                      size: 20,
                                    ),
                                  ),
                          ),
                          title: Text(
                            track.name,
                            style: AppTextStyles.font16WhiteSemiBold,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            track.artists.isNotEmpty
                                ? track.artists.first.name
                                : 'Unknown Artist',
                            style: AppTextStyles.font12GreyRegular,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(
                            Icons.more_horiz,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                  if (state.albums.isNotEmpty) ...[
                    Text(
                      'Albums',
                      style: AppTextStyles.font18WhiteSemiBold,
                    ),
                    const SizedBox(height: 12),
                    ...state.albums.map((album) {
                      final imageUrl = album.images.isNotEmpty
                          ? album.images.first.url
                          : null;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: imageUrl != null
                                  ? Image.network(
                                      imageUrl,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 56,
                                        height: 56,
                                        color: AppColors.cardBg,
                                        child: const Icon(
                                          Icons.album,
                                          color: AppColors.accent,
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 56,
                                      height: 56,
                                      color: AppColors.cardBg,
                                      child: const Icon(
                                        Icons.album,
                                        color: AppColors.accent,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    album.name,
                                    style: AppTextStyles.font16WhiteSemiBold,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    album.artists?.isNotEmpty == true
                                        ? album.artists!.first.name
                                        : 'Unknown Artist',
                                    style: AppTextStyles.font12GreyRegular,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                  const SizedBox(height: 140),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
