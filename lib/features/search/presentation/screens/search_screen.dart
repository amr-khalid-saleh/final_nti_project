import 'package:flutter/material.dart';
import '../widgets/categories_grid.dart';
import '../widgets/search_app_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/browse_categories_title.dart';
import '../widgets/trending_artists_section.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const SearchAppBar(),

                const SizedBox(height: 20),
                const SearchBarWidget(),

                const SizedBox(height: 32),

                const BrowseCategoriesTitle(),
                const SizedBox(height: 16),

                // Categories Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05,
                  children: const [
                    CategoryCard(
                      title: 'Rock & Roll',
                      imagePath: 'assets/card1.png',
                      icon: Icons.electric_bolt,
                    ),
                    CategoryCard(
                      title: 'Electronic\nBeats',
                      imagePath: 'assets/card2.png',
                      icon: Icons.music_note,
                    ),
                    CategoryCard(
                      title: 'Lo-Fi Study',
                      imagePath: 'assets/card3.png',
                      icon: Icons.coffee,
                    ),
                    CategoryCard(
                      title: 'Jazz Nights',
                      imagePath: 'assets/card4.png',
                      icon: Icons.nightlight_round,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Trending Artists
                const TrendingArtistsSection(),

                const SizedBox(height: 40),

                // Discover Section (placeholder)
                const Placeholder(fallbackHeight: 220),
              ],
            ),
          ),
        ),
      ),
    );
  }
}