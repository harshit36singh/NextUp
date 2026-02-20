import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/favorite_item.dart';
import 'models/shared_list.dart';
import 'models/watched_item.dart';
import 'providers/favorites_provider.dart';
import 'providers/releases_provider.dart';
import 'providers/shared_lists_provider.dart';
import 'providers/watched_provider.dart';
import 'providers/recommendations_provider.dart';
import 'services/notification_service.dart';
import 'navigation/main_navigation.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteItemAdapter());
  Hive.registerAdapter(SharedListAdapter());
  Hive.registerAdapter(WatchedItemAdapter());

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => ReleasesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WatchedProvider()..initialize(),
        ),
        ChangeNotifierProxyProvider<FavoritesProvider, SharedListsProvider>(
          create: (context) => SharedListsProvider(
            Provider.of<FavoritesProvider>(context, listen: false),
          )..initialize(),
          update: (context, favoritesProvider, previous) =>
              previous ?? SharedListsProvider(favoritesProvider)..initialize(),
        ),
        ChangeNotifierProxyProvider2<FavoritesProvider, ReleasesProvider, RecommendationsProvider>(
          create: (context) => RecommendationsProvider(
            Provider.of<FavoritesProvider>(context, listen: false),
            Provider.of<ReleasesProvider>(context, listen: false),
          ),
          update: (context, favorites, releases, previous) =>
              previous ?? RecommendationsProvider(favorites, releases),
        ),
      ],
      child: MaterialApp(
        title: 'NextUp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigation(),
      ),
    );
  }
}
