import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/core/shared_widgets/main_scaffold.dart';
import 'package:musix/core/theming/app_colors.dart';
import 'package:musix/core/theming/app_text_styles.dart';
import 'package:musix/core/utils/player_utils.dart';
import 'package:musix/features/search/cubit/category_tracks_cubit.dart';
import 'package:musix/features/search/cubit/category_tracks_state.dart';

class CategoryTracksScreen extends StatefulWidget {
  final CategoryModel category;

  const CategoryTracksScreen({super.key, required this.category});

  @override
  State<CategoryTracksScreen> createState() => _CategoryTracksScreenState();
}

class _CategoryTracksScreenState extends State<CategoryTracksScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryTracksCubit>().fetchCategoryTracks(widget.category.id);
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 1,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1E1E1E), AppColors.scaffoldBg],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleIcon(
                        Icons.arrow_back,
                        onTap: () => Navigator.pop(context),
                      ),
                      Text(
                        '${widget.category.name} Tracks',
                        style: AppTextStyles.font18WhiteSemiBold,
                      ),
                      const SizedBox(width: 40), // Spacing for alignment
                    ],
                  ),
                ),
                Expanded(
                  child: BlocBuilder<CategoryTracksCubit, CategoryTracksState>(
                    builder: (context, state) {
                      if (state is CategoryTracksLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: AppColors.accent),
                        );
                      } else if (state is CategoryTracksError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.message, style: AppTextStyles.font14WhiteMedium),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<CategoryTracksCubit>()
                                    .fetchCategoryTracks(widget.category.id),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      } else if (state is CategoryTracksLoaded) {
                        if (state.tracks.isEmpty) {
                          return Center(
                            child: Text(
                              'No tracks found for this category',
                              style: AppTextStyles.font14WhiteMedium,
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: EdgeInsets.only(bottom: 200.h, top: 20.h),
                          itemCount: state.tracks.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final track = state.tracks[index];
                            return _trackTile(context, track);
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: const BoxDecoration(
          color: Colors.black26,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20.sp),
      ),
    );
  }

  Widget _trackTile(BuildContext context, TrackModel track) {
    return InkWell(
      onTap: () => playTrackAndNavigate(context, track),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                image: DecorationImage(
                  image: NetworkImage(
                    track.album?.images.isNotEmpty == true
                        ? track.album!.images.first.url
                        : 'https://images.unsplash.com/photo-1514525253361-bee8a187c9bc?auto=format&fit=crop&w=100&q=80',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name,
                    style: AppTextStyles.font14WhiteMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    track.artists.isNotEmpty ? track.artists.first.name : 'Unknown',
                    style: AppTextStyles.font12GreyRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.more_horiz, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
