import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/features/auth/presentation/screens/login_screen.dart';
import 'package:musix/features/auth/presentation/screens/signup_screen.dart';
import 'package:musix/core/injection/injection_container.dart' as di;
import 'package:musix/features/home/cubit/home_cubit.dart';
import 'package:musix/features/search/cubit/search_cubit.dart';
import 'package:musix/features/library/cubit/library_cubit.dart';
import 'package:musix/features/profile/cubit/profile_cubit.dart';
import '../utils/app_routes.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding1_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding2_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding3_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/now_playing/presentation/screens/now_playing_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/library/presentation/screens/album_details_screen.dart';
import '../../features/library/presentation/screens/artist_details_screen.dart';
import '../../features/library/presentation/screens/playlist_details_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

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

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.sl<HomeCubit>(),
            child: const HomeScreen(),
          ),
        );

      case AppRoutes.search:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.sl<SearchCubit>(),
            child: const SearchScreen(),
          ),
        );

      case AppRoutes.nowPlaying:
        return MaterialPageRoute(builder: (_) => const NowPlayingScreen());

      case AppRoutes.library:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.sl<LibraryCubit>(),
            child: const LibraryScreen(),
          ),
        );

      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => di.sl<ProfileCubit>(),
            child: const ProfileScreen(),
          ),
        );

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
