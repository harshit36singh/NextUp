class ReleaseItem {
  final String id;
  final String title;
  final String? posterPath;
  final DateTime releaseDate;
  final String contentType;
  final String? platform;
  final List<String> genres;
  final int? runtime;
  final String? overview;
  final String? backdropPath;
  final List<String> platforms;
  final String releaseType; // 'theatrical', 'streaming', 'tv', 'digital'

  ReleaseItem({
    required this.id,
    required this.title,
    this.posterPath,
    required this.releaseDate,
    required this.contentType,
    this.platform,
    this.genres = const [],
    this.runtime,
    this.overview,
    this.backdropPath,
    this.platforms = const [],
    this.releaseType = 'theatrical',
  });

  bool get isReleased => DateTime.now().isAfter(releaseDate);

  int get daysUntilRelease {
    if (isReleased) return 0;
    return releaseDate.difference(DateTime.now()).inDays;
  }

  String get countdownText {
    if (isReleased) return 'Released';
    final days = daysUntilRelease;
    if (days == 0) return 'Today';
    if (days == 1) return 'Tomorrow';
    return '$days days';
  }

  factory ReleaseItem.fromTMDB(Map<String, dynamic> json, String type) {
    // Extract platforms from watch providers if available
    final watchProviders = json['watch/providers']?['results']?['US']?['flatrate'] as List?;
    final platforms = watchProviders?.map((p) => p['provider_name'] as String).toList() ?? <String>[];
    
    // Clean overview from HTML tags
    String? cleanOverview = json['overview'];
    if (cleanOverview != null) {
      cleanOverview = cleanOverview
          .replaceAll(RegExp(r'<br\s*/?>'), '\n')
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .trim();
    }
    
    return ReleaseItem(
      id: '${type}_${json['id']}',
      title: json['title'] ?? json['name'] ?? 'Unknown',
      posterPath: json['poster_path'],
      releaseDate: DateTime.parse(
        json['release_date'] ?? json['first_air_date'] ?? DateTime.now().toString(),
      ),
      contentType: type,
      genres: (json['genre_ids'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      overview: cleanOverview,
      backdropPath: json['backdrop_path'],
      runtime: json['runtime'],
      platforms: platforms,
      releaseType: type == 'movie' ? 'theatrical' : 'tv',
    );
  }

  factory ReleaseItem.fromAniList(Map<String, dynamic> json) {
    final startDate = json['startDate'];
    DateTime releaseDate;
    
    if (startDate != null && startDate['year'] != null) {
      releaseDate = DateTime(
        startDate['year'] ?? DateTime.now().year,
        startDate['month'] ?? 1,
        startDate['day'] ?? 1,
      );
    } else {
      releaseDate = DateTime.now();
    }

    // Clean HTML from description
    String? cleanDescription = json['description'];
    if (cleanDescription != null) {
      cleanDescription = cleanDescription
          .replaceAll(RegExp(r'<br\s*/?>'), '\n')
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&quot;', '"')
          .replaceAll('&amp;', '&')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>')
          .trim();
    }

    // Detect platforms for anime
    final format = json['format'] as String?;
    List<String> platforms = [];
    if (format == 'TV') {
      platforms = ['Crunchyroll', 'Funimation'];
    } else if (format == 'ONA') {
      platforms = ['Netflix', 'Crunchyroll'];
    }

    return ReleaseItem(
      id: 'anime_${json['id']}',
      title: json['title']?['english'] ?? 
             json['title']?['romaji'] ?? 
             'Unknown',
      posterPath: json['coverImage']?['large'],
      releaseDate: releaseDate,
      contentType: 'anime',
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
      overview: cleanDescription,
      runtime: json['duration'],
      platforms: platforms,
      releaseType: format ?? 'tv',
    );
  }
}
