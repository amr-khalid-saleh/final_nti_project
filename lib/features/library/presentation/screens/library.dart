import '../../../../core/shared_widgets/main_scaffold.dart';

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
    return MainScaffold(
      currentIndex: 2,
      body: Column(
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
                _playlistsView(),
                _artistsView(),
                _albumsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _playlistsView() {
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
                            '1,248 tracks',
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
              'RECENTLY MODIFIED',
              style: AppTextStyles.font11GreyMedium,
            ),
          ),
          _itemTile(
            'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=200&q=80',
            'Midnight Jazz',
            'Playlist · 42 songs',
            AppRoutes.playlistDetails,
          ),
          _itemTile(
            'https://images.unsplash.com/photo-1514525253361-bee8a187c9bc?auto=format&fit=crop&w=200&q=80',
            'High Energy',
            'Playlist · 18 songs',
            AppRoutes.playlistDetails,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('FOLDERS', style: AppTextStyles.font11GreyMedium),
                Text('New Folder', style: AppTextStyles.font13AccentSemiBold),
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
    );
  }

  Widget _artistsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('FOLLOWED ARTISTS', style: AppTextStyles.font11GreyMedium),
          ),
          _itemTile(
            'https://images.unsplash.com/photo-1520127873587-434cd6439b1e?auto=format&fit=crop&w=200&q=80',
            'Neon Dreams',
            'Artist · 1.2M monthly listeners',
            AppRoutes.artistDetails,
          ),
          _itemTile(
            'https://images.unsplash.com/photo-1493225255756-d9584f8606e9?auto=format&fit=crop&w=200&q=80',
            'The Architect',
            'Artist · 850K monthly listeners',
            AppRoutes.artistDetails,
          ),
        ],
      ),
    );
  }

  Widget _albumsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('SAVED ALBUMS', style: AppTextStyles.font11GreyMedium),
          ),
          _itemTile(
            'https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?auto=format&fit=crop&w=200&q=80',
            'Solaris Fade',
            'Album · Neon Dreams',
            AppRoutes.albumDetails,
          ),
          _itemTile(
            'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=200&q=80',
            'Dark Waves',
            'Album · The Architect',
            AppRoutes.albumDetails,
          ),
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
                    Text(title, style: AppTextStyles.font16WhiteMedium),
                    const SizedBox(height: 4),
                    Text(subtitle, style: AppTextStyles.font12GreyRegular),
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
          const Icon(Icons.folder_rounded,
              color: AppColors.textSecondary, size: 36),
          const SizedBox(height: 12),
          Text(name, style: AppTextStyles.font14WhiteMedium),
          const SizedBox(height: 4),
          Text(count, style: AppTextStyles.font12GreyRegular),
        ],
      ),
    );
  }
}
