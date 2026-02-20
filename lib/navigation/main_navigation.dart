import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/home_screen.dart';
import '../screens/content_type_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/shared_lists_screen.dart';
import '../screens/timeline_screen.dart';
import '../theme/app_theme.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;
  
  final Map<int, Widget> _cachedPages = {};

  Widget _getPage(int index) {
    if (_cachedPages.containsKey(index)) {
      return _cachedPages[index]!;
    }

    Widget page;
    switch (index) {
      case 0:
        page = const HomeScreen();
        break;
      case 1:
        page = const ContentTypeScreen(contentType: 'movie');
        break;
      case 2:
        page = const ContentTypeScreen(contentType: 'tv');
        break;
      case 3:
        page = const ContentTypeScreen(contentType: 'anime');
        break;
      case 4:
        page = const TimelineScreen();
        break;
      case 5:
        page = const FavoritesScreen();
        break;
      case 6:
        page = const SharedListsScreen();
        break;
      default:
        page = const HomeScreen();
    }
    
    _cachedPages[index] = page;
    return page;
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return; // Prevent reload
    
    HapticFeedback.lightImpact();
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: List.generate(7, (index) => _getPage(index)),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 64,
        decoration: BoxDecoration(
          color: AppTheme.cardBlack,
          border: Border.all(color: AppTheme.borderGray, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, "ALL", 0),
            _buildNavItem(Icons.movie, "MOVIES", 1),
            _buildNavItem(Icons.tv, "TV", 2),
            _buildNavItem(Icons.animation, "ANIME", 3),
            _buildNavItem(Icons.timeline, "TIME", 4),
            _buildNavItem(Icons.favorite, "FAVES", 5),
            _buildNavItem(Icons.share, "LISTS", 6),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.accentGold : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? AppTheme.primaryBlack : AppTheme.textGray,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: isSelected ? AppTheme.primaryBlack : AppTheme.textGray,
                letterSpacing: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
