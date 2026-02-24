import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 3)
class UserProfile extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String username;

  @HiveField(2)
  String? bio;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  Map<String, int> genrePreferences; // genre -> count

  @HiveField(5)
  Map<String, int> contentTypePreferences; // movie/tv/anime -> count

  @HiveField(6)
  int totalFavorites;

  @HiveField(7)
  int totalWatched;

  UserProfile({
    required this.id,
    required this.username,
    this.bio,
    DateTime? createdAt,
    Map<String, int>? genrePreferences,
    Map<String, int>? contentTypePreferences,
    this.totalFavorites = 0,
    this.totalWatched = 0,
  })  : createdAt = createdAt ?? DateTime.now(),
        genrePreferences = genrePreferences ?? {},
        contentTypePreferences = contentTypePreferences ?? {};

  // Generate shareable profile card data
  String getTopGenre() {
    if (genrePreferences.isEmpty) return 'None';
    final sorted = genrePreferences.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  String getTopContentType() {
    if (contentTypePreferences.isEmpty) return 'None';
    final sorted = contentTypePreferences.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.first.key;
  }

  List<String> getTopGenres({int count = 3}) {
    if (genrePreferences.isEmpty) return [];
    final sorted = genrePreferences.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(count).map((e) => e.key).toList();
  }

  String generateProfileLink() {
    return 'nextup://profile/$id';
  }

  String generateShareText() {
    final topGenres = getTopGenres().join(', ');
    return '''
Check out $username's taste on NextUp!

Top Genres: $topGenres
Favorites: $totalFavorites
Watched: $totalWatched

View Profile: ${generateProfileLink()}
View Favorites: nextup://list/$id
''';
  }
}
