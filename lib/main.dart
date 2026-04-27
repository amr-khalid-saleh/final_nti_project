import 'package:flutter/material.dart';
import 'core/theming/app_theme.dart';
import 'core/utils/app_routes.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/now_playing/presentation/screens/now_playing_screen.dart';
import 'features/profile/presentation/screens/settings_screen.dart';

void main() {
  runApp(const MusixApp());
}

class MusixApp extends StatelessWidget {
  const MusixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musix',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home:       (_) => const HomeScreen(),
        AppRoutes.nowPlaying: (_) => const NowPlayingScreen(),
        AppRoutes.settings:   (_) => const SettingsScreen(),
      },
    );
  }
}
