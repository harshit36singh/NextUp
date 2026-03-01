import 'package:flutter/foundation.dart';
import '../models/release_item.dart';
import 'favorites_provider.dart';
import 'releases_provider.dart';

class RecommendationsProvider extends ChangeNotifier {
  final FavoritesProvider _favoritesProvider;
  final ReleasesProvider _releasesProvider;

  RecommendationsProvider(this._favoritesProvider, this._releasesProvider);

  List<ReleaseItem> getRecommendations() {
    final favorites = _favoritesProvider.favorites;
    if (favorites.isEmpty) return [];

    // Count genre frequencies in favorites
    final genreCounts = <String, int>{};
    final contentTypeCounts = <String, int>{};

    for (final fav in favorites) {
      contentTypeCounts[fav.contentType] = 
          (contentTypeCounts[fav.contentType] ?? 0) + 1;
      
      if (fav.genres != null) {
        for (final genre in fav.genres!) {
          genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
        }
      }
    }

    // Get top 3 genres
    final topGenres = genreCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final preferredGenres = topGenres.take(3).map((e) => e.key).toList();

    // Get preferred content type
    final topContentType = contentTypeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final preferredType = topContentType.isNotEmpty ? topContentType.first.key : null;

    // Filter releases that match preferences
    final allReleases = _releasesProvider.releases;
    final matchingReleases = allReleases.where((release) {
      // Not already favorited
      if (_favoritesProvider.isFavorite(release.id)) return false;
      
      // Match content type if strong preference
      if (preferredType != null && contentTypeCounts[preferredType]! > 3) {
        if (release.contentType != preferredType) return false;
      }
      
      // Match at least one genre
      if (preferredGenres.isEmpty) return true;
      return release.genres.any((g) => preferredGenres.contains(g));
    }).toList();

    // Sort by release date (soonest first)
    matchingReleases.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));

    // Return top 3
    return matchingReleases.take(3).toList();
  }

  bool get hasRecommendations {
    return _favoritesProvider.totalFavorites >= 2;
  }
}
