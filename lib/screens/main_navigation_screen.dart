import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'profile_screen.dart';
import '../widgets/custom_bottom_nav.dart';
import '../data/mock_data.dart';
import '../models/hotel_model.dart';
import '../widgets/hotel_card.dart';
import '../widgets/custom_button.dart';
import '../theme/app_theme.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomeScreen(
            onSearchTap: () => _onTabTapped(1),
            onProfileTap: () => _onTabTapped(3),
          ),
          SearchScreen(
            onBackToHome: () => _onTabTapped(0),
          ),
          FavoritesScreen(
            onExploreTap: () => _onTabTapped(1),
          ),
          ProfileScreen(
            onFavoritesTap: () => _onTabTapped(2),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// Favorites Screen with full interactivity
class FavoritesScreen extends StatefulWidget {
  final VoidCallback? onExploreTap;
  const FavoritesScreen({super.key, this.onExploreTap});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late List<Hotel> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = List.from(MockData.recommendedHotels);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Saved Favorites',
          style: TextStyle(
            color: AppTheme.textDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: _favorites.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLime.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 40,
                          color: AppTheme.darkNavy,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Favorites Yet',
                        style: TextStyle(
                          color: AppTheme.textDark,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Start exploring breathtaking destinations and save your favorite places here.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textMuted,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Explore Destinations',
                        onPressed: () {
                          if (widget.onExploreTap != null) {
                            widget.onExploreTap!();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                physics: const BouncingScrollPhysics(),
                itemCount: _favorites.length,
                itemBuilder: (context, index) {
                  final hotel = _favorites[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: HotelCard(
                      hotel: hotel,
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          '/hotel_details',
                          arguments: hotel,
                        );
                      },
                      onFavoriteToggle: (isFav) {
                        if (!isFav) {
                          setState(() {
                            _favorites.removeAt(index);
                          });
                        }
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
