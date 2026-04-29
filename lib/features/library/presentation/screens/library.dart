import 'package:flutter/material.dart';
import '../../../../core/theming/app_colors.dart';
import '../../../../core/theming/app_text_styles.dart';
import '../../../../core/shared_widgets/app_bottom_nav_bar.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/shared_widgets/app_mini_player.dart';

class MusicLibraryPage extends StatefulWidget {
  const MusicLibraryPage({super.key});

  @override
  State<MusicLibraryPage> createState() => _MusicLibraryPageState();
}

class _MusicLibraryPageState extends State<MusicLibraryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
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
              child: const Icon(Icons.person, color: AppColors.textSecondary, size: 20),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TabBar with Playlists, Artists, Albums
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
                // Liked Songs Card
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
                            image: NetworkImage('https://images.unsplash.com/photo-1493225255756-d9584f8606e9?auto=format&fit=crop&w=800&q=80'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(context, AppRoutes.playlistDetails),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.favorite, color: AppColors.accent, size: 32),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Liked Songs',
                                    style: AppTextStyles.font28WhiteExtraBold,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '1,248 tracks',
                                    style: AppTextStyles.font14WhiteMedium.copyWith(color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: AppColors.accent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4)),
                            ],
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
                        ),
                      ),
                    ],
                  ),
                ),
                // Recently Modified Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'RECENTLY MODIFIED',
                    style: AppTextStyles.font11GreyMedium,
                  ),
                ),
                _playlistTile(
                  context,
                  'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=200&q=80',
                  'Midnight Jazz',
                  'Playlist · 42 songs',
                ),
                _playlistTile(
                  context,
                  'https://images.unsplash.com/photo-1514525253361-bee8a187c9bc?auto=format&fit=crop&w=200&q=80',
                  'High Energy',
                  'Playlist · 18 songs',
                ),
                _playlistTile(
                  context,
                  'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=200&q=80',
                  'Late Night Drive',
                  'Playlist · 68 songs',
                ),
                const SizedBox(height: 24),
                // Folders Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FOLDERS',
                        style: AppTextStyles.font11GreyMedium,
                      ),
                      Text(
                        'New Folder',
                        style: AppTextStyles.font13AccentSemiBold,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(child: _folderTile('Archives', '12 items')),
                      const SizedBox(width: 12),
                      Expanded(child: _folderTile('Production', '9 items')),
                    ],
                  ),
                ),
              ],
            ),
          ),
            const Positioned(
              bottom: 110,
              left: 16,
              right: 16,
              child: AppMiniPlayer(),
            ),

            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: AppBottomNavBar(currentIndex: 2),
            ),
        ],
      ),
    );
  }

  Widget _playlistTile(BuildContext context, String imageUrl, String title, String subtitle) {
    return InkWell(
      onTap: () {
        if (title == 'Midnight Jazz') {
           Navigator.pushNamed(context, AppRoutes.playlistDetails);
        } else if (title == 'High Energy') {
           Navigator.pushNamed(context, AppRoutes.albumDetails);
        } else {
           Navigator.pushNamed(context, AppRoutes.artistDetails);
        }
      },
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
                  borderRadius: BorderRadius.circular(8),
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
                    Text(
                      title,
                      style: AppTextStyles.font16WhiteMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.font12GreyRegular,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: AppColors.textHint),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _folderTile(String name, String count) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.folder_rounded, color: AppColors.textSecondary, size: 36),
          const SizedBox(height: 12),
          Text(name, style: AppTextStyles.font14WhiteMedium),
          const SizedBox(height: 4),
          Text(count, style: AppTextStyles.font12GreyRegular),
        ],
      ),
    );
  }
}
