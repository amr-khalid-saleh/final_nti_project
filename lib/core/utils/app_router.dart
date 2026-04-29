import 'package:flutter/material.dart';
import '../utils/app_routes.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding1_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding2_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding3_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/now_playing/presentation/screens/now_playing_screen.dart';
import '../../features/library/presentation/screens/library.dart';
import '../../features/library/presentation/screens/album_details_screen.dart';
import '../../features/library/presentation/screens/artist_details_screen.dart';

import '../../features/library/presentation/screens/playlist_details_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      
      case AppRoutes.onboarding2:
        return MaterialPageRoute(builder: (_) => const Onboarding2Screen());

      case AppRoutes.onboarding3:
        return MaterialPageRoute(builder: (_) => const Onboarding3Screen());
      
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      
      case AppRoutes.nowPlaying:
        return MaterialPageRoute(builder: (_) => const NowPlayingScreen());
      
      case AppRoutes.library:
        return MaterialPageRoute(builder: (_) => const MusicLibraryPage());
      
      case AppRoutes.albumDetails:
        return MaterialPageRoute(builder: (_) => const AlbumDetailsScreen());
      
      case AppRoutes.artistDetails:
        return MaterialPageRoute(builder: (_) => const ArtistDetailsScreen());

      case AppRoutes.playlistDetails:
        return MaterialPageRoute(builder: (_) => const PlaylistDetailsScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
