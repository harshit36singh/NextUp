import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import '../models/shared_list.dart';
import '../models/release_item.dart';
import 'favorites_provider.dart';

class SharedListsProvider extends ChangeNotifier {
  static const String boxName = 'shared_lists';
  Box<SharedList>? _box;
  final FavoritesProvider _favoritesProvider;

  SharedListsProvider(this._favoritesProvider);

  Future<void> initialize() async {
    _box = await Hive.openBox<SharedList>(boxName);
    notifyListeners();
  }

  List<SharedList> get lists {
    if (_box == null) return [];
    return _box!.values.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<String> createSharedList({
    required String title,
    String? description,
    required List<String> itemIds,
  }) async {
    if (_box == null) return '';

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final sharedList = SharedList(
      id: id,
      title: title,
      description: description,
      itemIds: itemIds,
    );

    await _box!.put(id, sharedList);
    notifyListeners();
    
    // Return the full shareable text, not just the link
    return sharedList.getShareText();
  }

  Future<String?> shareList(String listId) async {
    final list = _box?.get(listId);
    if (list == null) return null;

    final shareText = list.getShareText();
    
    try {
      await Share.share(
        shareText,
        subject: list.title,
      );
      return shareText;
    } catch (e) {
      print('Error sharing: $e');
      return null;
    }
  }

  SharedList? getListById(String id) {
    if (_box == null) return null;
    return _box!.get(id);
  }

  List<ReleaseItem> getListItems(String listId) {
    final list = getListById(listId);
    if (list == null) return [];

    final items = <ReleaseItem>[];
    for (final itemId in list.itemIds) {
      final favorite = _favoritesProvider.getFavorite(itemId);
      if (favorite != null) {
        items.add(ReleaseItem(
          id: favorite.id,
          title: favorite.title,
          posterPath: favorite.posterPath,
          releaseDate: favorite.releaseDate,
          contentType: favorite.contentType,
          platform: favorite.platform,
          genres: favorite.genres ?? [],
          runtime: favorite.runtime,
          overview: favorite.overview,
        ));
      }
    }
    return items;
  }

  Future<void> deleteList(String id) async {
    if (_box == null) return;
    await _box!.delete(id);
    notifyListeners();
  }

  Future<void> importSharedList(String link) async {
    // Extract ID from link: nextup://list/{id}
    final uri = Uri.parse(link);
    if (uri.scheme != 'nextup' || uri.host != 'list') return;
    
    final id = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : null;
    if (id == null) return;

    // In a real app, you'd fetch this from a server
    // For now, we'll just check if it exists locally
    final list = getListById(id);
    if (list != null) {
      notifyListeners();
    }
  }

  int get totalLists => _box?.length ?? 0;
}
