import '../../../../core/shared_widgets/main_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // App Bar
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
                        Text('EVENING, ALEX',
                            style: AppTextStyles.font11GreyMedium),
                        Text('Welcome back',
                            style: AppTextStyles.font22WhiteBold),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.search,
                          color: AppColors.textPrimary, size: 22),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Speed Dial
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Speed Dial', style: AppTextStyles.font18WhiteSemiBold),
                    Text('View History',
                        style: AppTextStyles.font13AccentSemiBold),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _speedDialItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final item = _speedDialItems[index];
                      return SpeedDialCard(
                        title: item['title']!,
                        subtitle: item['subtitle']!,
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.nowPlaying),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                // Trending Now
                Text('Trending Now', style: AppTextStyles.font18WhiteSemiBold),
                const SizedBox(height: 12),
                ...List.generate(_trendingItems.length, (index) {
                  final item = _trendingItems[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TrendingTile(
                      title: item['title']!,
                      artist: item['artist']!,
                      duration: item['duration']!,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.nowPlaying),
                    ),
                  );
                }),
                const SizedBox(height: 24),
                // Fresh Finds
                Text('Fresh Finds', style: AppTextStyles.font18WhiteSemiBold),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _freshFindsItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final item = _freshFindsItems[index];
                    return FreshFindCard(
                      title: item['title']!,
                      genre: item['genre']!,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.nowPlaying),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

const _speedDialItems = [
  {'title': 'Late Night Echoes', 'subtitle': 'Techno · 24 Tracks'},
  {'title': 'Solaris Fade',      'subtitle': 'Ambient · 18 Tracks'},
  {'title': 'Dark Waves',        'subtitle': 'Electronic · 12 Tracks'},
];

const _trendingItems = [
  {'title': 'Midnight Motion', 'artist': 'Neon Velocity',   'duration': '3:42'},
  {'title': 'Glass Horizon',   'artist': 'The Architect',   'duration': '4:15'},
  {'title': 'Raw Sessions',    'artist': 'Unplugged Kings', 'duration': '5:01'},
];

const _freshFindsItems = [
  {'title': 'Liquid States', 'genre': 'EXPERIMENTAL'},
  {'title': 'Urban Pulse',   'genre': 'ELECTRONIC'},
  {'title': 'Echo Park',     'genre': 'INDIE ROCK'},
  {'title': 'Morning Mist',  'genre': 'ACOUSTIC'},
];
