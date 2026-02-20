# NextUp

A minimal Flutter mobile app for tracking upcoming releases of movies, TV shows, and anime. The app provides a clean, spoiler-free interface to discover and track content you're interested in, with local notifications for release dates.

## Features

### Core Features
- **Multi-source tracking**: Movies and TV shows (via TMDB), Anime (via AniList)
- **Time-based browsing**: View releases for today, this week, or this month
- **Content filtering**: Filter by content type (Movies, TV Shows, Anime) and genre
- **Chronological layout**: All releases sorted by date with countdown timers
- **Blind mode**: Spoiler-safe browsing with minimal details visible

### Favorites System
- Save items you're interested in with a single tap
- Favorites highlighted with release date countdowns
- Dedicated favorites screen sorted by release date
- Separate sections for upcoming and released content
- Local notifications on or before release day
- Offline-first: All favorites stored locally with Hive

### Clean Design
- Minimal, opinion-free UI showing only factual metadata
- No ratings, reviews, or comments
- Fast, responsive interface
- Pull-to-refresh for latest data
- Smooth scrolling and animations

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Android Studio / Xcode for mobile development
- TMDB API key (free, see below)

### Getting Your TMDB API Key
1. Go to https://www.themoviedb.org/
2. Create a free account
3. Navigate to Settings → API
4. Request an API key (choose "Developer" option)
5. Copy your API key

### Installation

1. **Clone or download this project**

2. **Install dependencies**
   ```bash
   cd release_tracker
   flutter pub get
   ```

3. **Add your TMDB API key**
   Open `lib/services/tmdb_service.dart` and replace:
   ```dart
   static const String apiKey = 'YOUR_TMDB_API_KEY_HERE';
   ```
   with your actual API key:
   ```dart
   static const String apiKey = 'your_actual_api_key_here';
   ```

4. **Run code generation for Hive** (if needed)
   ```bash
   flutter pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Usage Guide

### Home Screen
- **Timeframe tabs**: Switch between Today, This Week, This Month
- **Content type chips**: Toggle Movies, TV Shows, Anime
- **Filter icon**: Filter by specific genres
- **Eye icon**: Toggle blind mode to hide details
- **Heart icon**: View your favorites (shows count badge)

### Adding Favorites
- Tap the heart icon on any release card
- Favorited items are highlighted with a filled heart
- Access all favorites via the heart icon in the app bar

### Managing Favorites
- Favorites screen shows upcoming and released items separately
- Each favorite shows a countdown timer
- Tap the bell icon to enable/disable notifications
- Tap the trash icon to remove from favorites
- Use "Clear All" to remove all favorites at once

### Notifications
- Enable notifications per favorite item
- Receive reminder 1 day before release
- Receive notification on release day at 9 AM
- Notifications include title, type, and key details

### Blind Mode
- Hides titles, posters, and detailed information
- Shows only basic metadata (type, date, countdown)
- Perfect for avoiding spoilers while tracking releases
- Toggle with the eye icon in the app bar

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/
│   ├── favorite_item.dart             # Hive model for favorites
│   ├── favorite_item.g.dart           # Generated Hive adapter
│   └── release_item.dart              # Release data model
├── services/
│   ├── tmdb_service.dart              # TMDB API integration
│   ├── anilist_service.dart           # AniList API integration
│   └── notification_service.dart      # Local notifications
├── providers/
│   ├── favorites_provider.dart        # Favorites state management
│   └── releases_provider.dart         # Releases state management
├── screens/
│   ├── home_screen.dart               # Main releases screen
│   └── favorites_screen.dart          # Favorites list screen
└── widgets/
    ├── release_card.dart              # Release item card
    └── favorite_card.dart             # Favorite item card
```

## API Information

### TMDB (The Movie Database)
- **Purpose**: Movies and TV shows data
- **Cost**: Free (with attribution)
- **Rate limits**: 40 requests per 10 seconds
- **Data includes**: Title, release date, poster, genres, runtime, overview
- **Documentation**: https://developers.themoviedb.org/3

### AniList
- **Purpose**: Anime data
- **Cost**: Free
- **Rate limits**: 90 requests per minute
- **Data includes**: Title, air date, cover image, genres, duration, description
- **Documentation**: https://anilist.gitbook.io/anilist-apiv2-docs/

## Privacy & Data

- **No user accounts**: Everything is local
- **No analytics**: No tracking or data collection
- **Offline-first**: Favorites stored locally with Hive
- **No social features**: Private, personal tracking only
- **API calls**: Only to TMDB and AniList for public release data

## Technical Details

### State Management
- **Provider**: For reactive state updates
- **Hive**: For local persistence

### Dependencies
- `provider`: State management
- `hive` & `hive_flutter`: Local database
- `http`: API requests
- `cached_network_image`: Image caching
- `flutter_local_notifications`: Local notifications
- `intl`: Date formatting
- `shimmer`: Loading placeholders

### Notification Scheduling
- Notifications scheduled at 9 AM on release day
- Additional reminder 1 day before
- Automatic cancellation when unfavorited
- Requires notification permissions on first use

## Customization Ideas

- Adjust notification time in `notification_service.dart`
- Modify timeframes in `releases_provider.dart`
- Change color scheme in `main.dart`
- Add more content types (books, games, etc.)
- Integrate additional APIs (IMDb, MyAnimeList, etc.)

## Troubleshooting

### API not returning data
- Verify your TMDB API key is correct
- Check internet connection
- Review API rate limits

### Notifications not working
- Ensure notification permissions are granted
- Check device battery optimization settings
- Verify date/time is set correctly

### Build errors
- Run `flutter clean` then `flutter pub get`
- Ensure Flutter SDK is up to date
- Check for dependency version conflicts

## License

This project is provided as-is for educational and personal use.

## Attribution

- Movie and TV show data provided by [The Movie Database (TMDB)](https://www.themoviedb.org/)
- Anime data provided by [AniList](https://anilist.co/)

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review API documentation
3. Verify your API keys are valid
4. Ensure all dependencies are installed correctly

---

**Note**: This app requires valid API keys to function. TMDB requires free registration, while AniList API is open. Make sure to respect API rate limits and terms of service.
