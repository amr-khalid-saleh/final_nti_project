import '../../../../core/shared_widgets/main_scaffold.dart';

class AlbumDetailsScreen extends StatelessWidget {
  const AlbumDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      currentIndex: 2,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Color(0xFF140606),
              Color(0xFF2B0906),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _circleIcon(context, Icons.arrow_back_ios_new),
                    _circleIcon(context, Icons.more_vert),
                  ],
                ),
                SizedBox(height: 26.h),
                Center(
                  child: Container(
                    width: 320.w,
                    padding: EdgeInsets.all(22.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1B1B),
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF3B1D).withValues(alpha: .28),
                          blurRadius: 40,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 210.w,
                          height: 210.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3B3B3B), Color(0xFF111111)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .55),
                                blurRadius: 30,
                                offset: const Offset(0, 15),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Container(
                              width: 100.w,
                              height: 100.w,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                    'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=format&fit=crop&w=500&q=80',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'SAFEE ON WORK',
                          style: AppTextStyles.font11GreyMedium.copyWith(
                              color: AppColors.textPrimary, letterSpacing: 2),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Solclone',
                          style: AppTextStyles.font12GreyRegular,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Center(
                  child: Text(
                    LibraryData.albumTitle,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.font28WhiteExtraBold.copyWith(
                        fontSize: 42.sp, color: const Color(0xFFFFD9D2)),
                  ),
                ),
                SizedBox(height: 12.h),
                Center(
                  child: Text(
                    '${LibraryData.albumArtist} • ${LibraryData.albumYear}',
                    style: AppTextStyles.font18WhiteSemiBold.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400),
                  ),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    const Expanded(
                      child: PrimaryActionButton(
                        text: 'PLAY ALBUM',
                        icon: Icons.play_arrow,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    _smallAction(Icons.favorite_border),
                    SizedBox(width: 12.w),
                    _smallAction(Icons.file_download_outlined),
                  ],
                ),
                SizedBox(height: 28.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tracklist',
                      style: TextStyle(color: Colors.white, fontSize: 24.sp),
                    ),
                    Text(
                      '12 tracks • 48 min',
                      style: TextStyle(color: Colors.white38, fontSize: 18.sp),
                    ),
                  ],
                ),
                SizedBox(height: 18.h),
                ...LibraryData.trackList.map(
                  (track) => TrackTile(
                    index: track['index'] as String,
                    title: track['title'] as String,
                    artist: track['artist'] as String,
                    duration: track['duration'] as String,
                    active: track['active'] as bool,
                  ),
                ),
                SizedBox(height: 26.h),
                Text(
                  'Similar Vibes',
                  style: TextStyle(color: Colors.white, fontSize: 24.sp),
                ),
                SizedBox(height: 18.h),
                Row(
                  children: LibraryData.similarVibes
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.only(right: 14.w),
                          child: SimilarVibeCard(
                            title: item['title']!,
                            artist: item['artist']!,
                            image: item['image']!,
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 200.h),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _smallAction(IconData icon) {
    return Container(
      width: 60.w,
      height: 52.h,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.white12),
      ),
      child: Icon(icon, color: Colors.white, size: 22.sp),
    );
  }
}