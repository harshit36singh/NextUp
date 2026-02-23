import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/releases_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/recommendations_provider.dart';
import '../widgets/release_card.dart';
import '../widgets/app_drawer.dart';
import '../widgets/classy_bottom_sheet.dart';
import '../widgets/minimal_loading.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReleasesProvider>(context, listen: false).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final releasesProvider = Provider.of<ReleasesProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.getBackgroundColor(context),
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppTheme.getBackgroundColor(context),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              color: AppTheme.getTextColor(context),
              size: 20,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('NEXTUP'),
        actions: [
          // Blind mode toggle
          IconButton(
            icon: Icon(
              releasesProvider.blindMode 
                  ? Icons.visibility_off 
                  : Icons.visibility,
              color: AppTheme.getTextColor(context),
              size: 20,
            ),
            onPressed: () {
              releasesProvider.toggleBlindMode();
            },
          ),
          // Genre filter
          IconButton(
            icon: Icon(
              Icons.tune,
              color: AppTheme.getTextColor(context),
              size: 20,
            ),
            onPressed: () => _showGenreFilter(context, releasesProvider),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Timeframe selector
          _buildTimeframeSelector(releasesProvider),
          // Active genre chips
          if (releasesProvider.selectedGenres.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildActiveGenres(releasesProvider),
          ],
          const SizedBox(height: 16),
          // Releases list with recommendations
          Expanded(
            child: _buildContent(releasesProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ReleasesProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: MinimalLoadingIndicator(size: 40),
      );
    }

    if (provider.error.isNotEmpty) {
      return _buildError(provider);
    }

    final releases = provider.filteredReleases;

    return RefreshIndicator(
      onRefresh: () => provider.fetchReleases(),
      color: AppTheme.accentGold,
      backgroundColor: AppTheme.cardBlack,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          // Recommendations section
          _buildRecommendations(),
          
          // All releases
          if (releases.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(48.0),
                child: Column(
                  children: [
                    Icon(Icons.movie_outlined, size: 64, color: AppTheme.textGray),
                    SizedBox(height: 16),
                    Text(
                      'NO RELEASES FOUND',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textGray,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ...releases.map((item) => ReleaseCard(
              item: item,
              blindMode: provider.blindMode,
            )),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Consumer2<RecommendationsProvider, ReleasesProvider>(
      builder: (context, recommendationsProvider, releasesProvider, child) {
        if (!recommendationsProvider.hasRecommendations) {
          return const SizedBox.shrink();
        }

        final recommendations = recommendationsProvider.getRecommendations();
        
        if (recommendations.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 3,
                    height: 16,
                    color: AppTheme.accentGold,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '3 THINGS YOU MIGHT LIKE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.accentGold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            ...recommendations.map((item) => ReleaseCard(
              item: item,
              blindMode: false,
            )),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 1,
                color: AppTheme.borderGray,
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildActiveGenres(ReleasesProvider provider) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: provider.selectedGenres.map((genreId) {
          final genreName = provider.getGenreName(genreId, 'movie');
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                final newGenres = List<String>.from(provider.selectedGenres);
                newGenres.remove(genreId);
                provider.setSelectedGenres(newGenres);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.getPrimaryColor(context),
                  border: Border.all(
                    color: AppTheme.getPrimaryColor(context),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      genreName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppTheme.getBackgroundColor(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.close,
                      size: 14,
                      color: AppTheme.getBackgroundColor(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showGenreFilter(BuildContext context, ReleasesProvider provider) {
    ClassyBottomSheet.show(
      context: context,
      title: 'Filter by Genre',
      height: 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select genres to filter releases',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.getSecondaryTextColor(context),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _buildGenreChips(provider),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ClassyButton(
                  label: 'Clear All',
                  isOutlined: true,
                  onPressed: () {
                    provider.setSelectedGenres([]);
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClassyButton(
                  label: 'Apply',
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGenreChips(ReleasesProvider provider) {
    final allGenres = <String, String>{};
    
    if (provider.selectedTypes.contains('movie')) {
      allGenres.addAll(provider.movieGenres);
    }
    if (provider.selectedTypes.contains('tv')) {
      allGenres.addAll(provider.tvGenres);
    }

    return allGenres.entries.map((entry) {
      final isSelected = provider.selectedGenres.contains(entry.key);
      return GestureDetector(
        onTap: () {
          final newGenres = List<String>.from(provider.selectedGenres);
          if (isSelected) {
            newGenres.remove(entry.key);
          } else {
            newGenres.add(entry.key);
          }
          provider.setSelectedGenres(newGenres);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppTheme.getPrimaryColor(context) 
                : Colors.transparent,
            border: Border.all(
              color: isSelected 
                  ? AppTheme.getPrimaryColor(context) 
                  : AppTheme.getBorderColor(context),
              width: 1,
            ),
          ),
          child: Text(
            entry.value.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: isSelected 
                  ? AppTheme.getBackgroundColor(context) 
                  : AppTheme.getTextColor(context),
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildError(ReleasesProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppTheme.textGray),
          const SizedBox(height: 16),
          Text(
            provider.error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.textGray),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => provider.fetchReleases(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: AppTheme.goldCardDecoration(context),
              child: const Text(
                'RETRY',
                style: TextStyle(
                  color: AppTheme.primaryBlack,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector(ReleasesProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 44,
      child: Row(
        children: [
          _buildTimeframeButton('TODAY', 'today', provider),
          const SizedBox(width: 12),
          _buildTimeframeButton('THIS WEEK', 'week', provider),
          const SizedBox(width: 12),
          _buildTimeframeButton('THIS MONTH', 'month', provider),
        ],
      ),
    );
  }

  Widget _buildTimeframeButton(String label, String value, ReleasesProvider provider) {
    final isSelected = provider.selectedTimeframe == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setTimeframe(value),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected 
                ? AppTheme.getPrimaryColor(context) 
                : AppTheme.getCardColor(context),
            border: Border.all(
              color: isSelected 
                  ? AppTheme.getPrimaryColor(context) 
                  : AppTheme.getBorderColor(context),
              width: 1,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected 
                  ? AppTheme.getBackgroundColor(context) 
                  : AppTheme.getTextColor(context),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}
