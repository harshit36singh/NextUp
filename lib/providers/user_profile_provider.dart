import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/user_profile.dart';
import 'favorites_provider.dart';
import 'watched_provider.dart';

class UserProfileProvider extends ChangeNotifier {
  static const String boxName = 'user_profiles';
  static const String currentUserKey = 'current_user_id';
  Box? _box;
  Box? _settingsBox;
  String? _currentUserId;
  UserProfile? _currentProfile;

  UserProfile? get currentProfile => _currentProfile;
  bool get hasProfile => _currentProfile != null;
  String? get currentUserId => _currentUserId;

  Future<void> initialize() async {
    _box = await Hive.openBox(boxName);
    _settingsBox = await Hive.openBox('settings');
    
    _currentUserId = _settingsBox?.get(currentUserKey);
    if (_currentUserId != null) {
      _currentProfile = _box?.get(_currentUserId);
    }
    notifyListeners();
  }

  // Get all profiles
  List<UserProfile> getAllProfiles() {
    if (_box == null) return [];
    return _box!.values.whereType<UserProfile>().toList();
  }

  // Create new profile
  Future<void> createProfile({
    required String username,
    String? bio,
  }) async {
    if (_box == null || _settingsBox == null) return;

    final profile = UserProfile(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      bio: bio,
    );

    await _box!.put(profile.id, profile);
    await _settingsBox!.put(currentUserKey, profile.id);
    
    _currentUserId = profile.id;
    _currentProfile = profile;
    notifyListeners();
  }

  // Switch to different profile
  Future<void> switchProfile(String profileId) async {
    if (_box == null || _settingsBox == null) return;
    
    final profile = _box!.get(profileId);
    if (profile != null && profile is UserProfile) {
      await _settingsBox!.put(currentUserKey, profileId);
      _currentUserId = profileId;
      _currentProfile = profile;
      notifyListeners();
    }
  }

  // Update current profile
  Future<void> updateProfile({
    String? username,
    String? bio,
  }) async {
    if (_currentProfile == null || _box == null) return;

    if (username != null) _currentProfile!.username = username;
    if (bio != null) _currentProfile!.bio = bio;

    await _box!.put(_currentProfile!.id, _currentProfile);
    notifyListeners();
  }

  // Update stats for current profile
  Future<void> updateStats(
    FavoritesProvider favoritesProvider,
    WatchedProvider watchedProvider,
  ) async {
    if (_currentProfile == null || _box == null) return;

    _currentProfile!.totalFavorites = favoritesProvider.totalFavorites;
    _currentProfile!.totalWatched = watchedProvider.totalWatched;

    // Update genre preferences
    final genreCounts = <String, int>{};
    for (final fav in favoritesProvider.favorites) {
      if (fav.genres != null) {
        for (final genre in fav.genres!) {
          genreCounts[genre] = (genreCounts[genre] ?? 0) + 1;
        }
      }
    }
    _currentProfile!.genrePreferences = genreCounts;

    // Update content type preferences
    final typeCounts = <String, int>{};
    for (final fav in favoritesProvider.favorites) {
      typeCounts[fav.contentType] = (typeCounts[fav.contentType] ?? 0) + 1;
    }
    _currentProfile!.contentTypePreferences = typeCounts;

    await _box!.put(_currentProfile!.id, _currentProfile);
    notifyListeners();
  }

  // Delete current profile
  Future<void> deleteCurrentProfile() async {
    if (_currentProfile == null || _box == null || _settingsBox == null) return;
    
    await _box!.delete(_currentProfile!.id);
    
    // Switch to another profile if available
    final remainingProfiles = getAllProfiles();
    if (remainingProfiles.isNotEmpty) {
      await switchProfile(remainingProfiles.first.id);
    } else {
      // No profiles left
      await _settingsBox!.delete(currentUserKey);
      _currentUserId = null;
      _currentProfile = null;
    }
    
    notifyListeners();
  }

  // Get profile by ID
  UserProfile? getProfileById(String id) {
    if (_box == null) return null;
    final profile = _box!.get(id);
    return profile is UserProfile ? profile : null;
  }
}
