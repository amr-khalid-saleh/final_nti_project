import 'package:flutter/material.dart';
import 'core/theming/app_theme.dart';
import 'core/utils/app_routes.dart';
import 'features/home/presentation/screens/home_screen.dart';

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
        AppRoutes.home:   (_) => const HomeScreen(),
      },
    );
  }
}
