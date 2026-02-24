import 'package:hive/hive.dart';
import 'release_item.dart';

part 'shared_list.g.dart';

@HiveType(typeId: 1)
class SharedList extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  List<String> itemIds; // ReleaseItem IDs

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  String createdBy;

  SharedList({
    required this.id,
    required this.title,
    this.description,
    required this.itemIds,
    DateTime? createdAt,
    this.createdBy = 'Anonymous',
  }) : createdAt = createdAt ?? DateTime.now();

  // Generate shareable link format: nextup://list/{id}
  String get shareableLink => 'nextup://list/$id';

  // Generate a readable share text
  String getShareText() {
    return '''
Check out my $title watchlist on NextUp!

${description ?? ''}

Open in NextUp: $shareableLink
''';
  }
}
