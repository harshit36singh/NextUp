import 'package:hive/hive.dart';

part 'favorite_item.g.dart';

@HiveType(typeId: 0)
class FavoriteItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? posterPath;

  @HiveField(3)
  DateTime releaseDate;

  @HiveField(4)
  String contentType; // 'movie', 'tv', 'anime'

  @HiveField(5)
  String? platform;

  @HiveField(6)
  List<String>? genres;

  @HiveField(7)
  int? runtime;

  @HiveField(8)
  String? overview;

  @HiveField(9)
  bool notificationEnabled;

  @HiveField(10)
  DateTime addedAt;

  FavoriteItem({
    required this.id,
    required this.title,
    this.posterPath,
    required this.releaseDate,
    required this.contentType,
    this.platform,
    this.genres,
    this.runtime,
    this.overview,
    this.notificationEnabled = false,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

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
}
