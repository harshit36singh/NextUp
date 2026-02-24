import 'package:hive/hive.dart';

part 'watched_item.g.dart';

@HiveType(typeId: 2)
class WatchedItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime watchedDate;

  @HiveField(3)
  String? privateNote;

  @HiveField(4)
  String contentType;

  WatchedItem({
    required this.id,
    required this.title,
    DateTime? watchedDate,
    this.privateNote,
    required this.contentType,
  }) : watchedDate = watchedDate ?? DateTime.now();
}
