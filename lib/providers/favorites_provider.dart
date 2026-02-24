import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/favorite_item.dart';
import '../models/release_item.dart';
import '../services/notification_service.dart';

class FavoritesProvider extends ChangeNotifier {
  static const String boxName = 'favorites';
  Box<FavoriteItem>? _box;
  final NotificationService _notificationService = NotificationService();

  Future<void> initialize() async {
    _box = await Hive.openBox<FavoriteItem>(boxName);
    notifyListeners();
  }

  List<FavoriteItem> get favorites {
    if (_box == null) return [];
    return _box!.values.toList()
      ..sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
  }

  List<FavoriteItem> get upcomingFavorites {
    return favorites.where((item) => !item.isReleased).toList();
  }

  List<FavoriteItem> get releasedFavorites {
    return favorites.where((item) => item.isReleased).toList();
  }

  bool isFavorite(String id) {
    if (_box == null) return false;
    return _box!.values.any((item) => item.id == id);
  }

  Future<void> addFavorite(ReleaseItem item) async {
    if (_box == null) return;

    final favorite = FavoriteItem(
      id: item.id,
      title: item.title,
      posterPath: item.posterPath,
      releaseDate: item.releaseDate,
      contentType: item.contentType,
      platform: item.platform,
      genres: item.genres,
      runtime: item.runtime,
      overview: item.overview,
      notificationEnabled: false,
    );

    await _box!.put(item.id, favorite);
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    if (_box == null) return;

    final item = _box!.get(id);
    if (item != null && item.notificationEnabled) {
      await _notificationService.cancelNotification(item);
    }

    await _box!.delete(id);
    notifyListeners();
  }

  Future<void> toggleNotification(String id) async {
    if (_box == null) return;

    final item = _box!.get(id);
    if (item == null) return;

    item.notificationEnabled = !item.notificationEnabled;
    
    if (item.notificationEnabled) {
      await _notificationService.scheduleReleaseNotification(item);
    } else {
      await _notificationService.cancelNotification(item);
    }

    await item.save();
    notifyListeners();
  }

  FavoriteItem? getFavorite(String id) {
    if (_box == null) return null;
    return _box!.get(id);
  }

  int get totalFavorites => _box?.length ?? 0;

  Future<void> clearAllFavorites() async {
    if (_box == null) return;

    // Cancel all notifications
    for (var item in _box!.values) {
      if (item.notificationEnabled) {
        await _notificationService.cancelNotification(item);
      }
    }

    await _box!.clear();
    notifyListeners();
  }
}
