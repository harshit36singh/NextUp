# NextUp 🎬

A sleek, minimal Flutter app with a premium black UI for tracking upcoming movies, TV shows, and anime releases. Discover and follow content you care about with a spoiler-free interface, local notifications, and shareable lists.

---

## ✨ Features

### 🎭 Multi-Source Tracking
- 🎥 Movies and TV shows via TMDB
- 🌸 Anime via AniList
- All content unified in a single chronological feed with countdown timers

### 📅 Time-Based Browsing
- Switch between **Today**, **This Week**, and **This Month**
- Filter by content type: Movies, TV Shows, Anime
- Filter further by specific genres

### ❤️ Favorites
- Save any item with a single tap
- Dedicated favorites screen with separate upcoming and released sections
- Release date countdowns on every saved item
- 📦 Offline-first: all favorites stored locally with Hive

### 🔔 Notifications
- Release day alert at 9 AM
- 1-day advance reminder
- Per-item toggle — enable or disable per favorite
- Auto-cancelled when an item is removed from favorites

### 🔗 Shareable Lists
- Create custom lists from your favorites with a title and description
- Select multiple items and generate a shareable link (`nextup://list/{id}`)
- Share via any app — WhatsApp, Telegram, iMessage, etc.
- Import lists from others by pasting a link
- All list data stays local; links contain IDs only

### 🙈 Blind Mode
- Toggle with the eye icon to hide titles (shown as ████████), posters, and details
- Shows only content type, release date, and countdown
- Perfect for spoiler-averse browsing

### 🖤 Clean Design
- Pure black interface with gold accents
- Square/boxed elements, 1px borders, no rounded corners
- Uppercase labels with increased letter spacing
- No ratings, reviews, or comments — factual metadata only
- Pull-to-refresh, shimmer loading placeholders, smooth scrolling

### 🧭 Navigation
A floating bottom navbar gives instant access to:

| Tab | Content |
|---|---|
| ALL | Every content type |
| MOVIES | 🎥 Movies only |
| TV | 📺 TV shows only |
| ANIME | 🌸 Anime only |
| FAVES | ❤️ Your favorites |
| LISTS | 📋 Your shared lists |

---

## 🎨 Design

| Element | Value |
|---|---|
| Background | `#000000` |
| Card | `#0A0A0A` |
| Accent | ✨ Gold `#E6B84E` |
| Typography | Sans-serif, uppercase, letter-spaced |
| Layout | Square elements, thin borders, minimal shadows |

---

## ⚙️ Setup

### 📋 Prerequisites
- Flutter SDK 3.0.0+
- Android Studio or Xcode
- Free TMDB API key

### 🔑 Getting a TMDB API Key
1. Create a free account at [themoviedb.org](https://www.themoviedb.org/)
2. Go to **Settings → API**
3. Request a Developer key and copy it

### 🚀 Installation

```bash
# 1. Install dependencies
cd release_tracker
flutter pub get

# 2. Run Hive code generation (if needed)
flutter pub run build_runner build

# 3. Run the app
flutter run
```

Then open `lib/services/tmdb_service.dart` and replace:
```dart
static const String apiKey = 'YOUR_TMDB_API_KEY_HERE';
```
with your actual key.

---

## 📖 How to Use

### ❤️ Adding Favorites
Tap the heart icon on any release card. Favorited items appear in the **FAVES** tab with countdowns and notification controls.

### 📤 Creating a Shareable List
1. Go to **FAVES**
2. Tap the Share icon
3. Enter a title and description
4. Select items to include
5. Tap **CREATE & SHARE** — the link is copied to your clipboard

### 📥 Importing a List
1. Open the **LISTS** tab
2. Tap the Import icon
3. Paste a `nextup://list/{id}` link

### 🙈 Blind Mode
Tap the eye icon in the app bar to toggle. All identifying details are hidden — only dates and countdowns remain visible.

---

## 🗂️ Project Structure

```
lib/
├── main.dart
├── models/
│   ├── favorite_item.dart
│   ├── favorite_item.g.dart
│   └── release_item.dart
├── services/
│   ├── tmdb_service.dart
│   ├── anilist_service.dart
│   └── notification_service.dart
├── providers/
│   ├── favorites_provider.dart
│   └── releases_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── favorites_screen.dart
│   └── lists_screen.dart
└── widgets/
    ├── release_card.dart
    └── favorite_card.dart
```

---

## 🌐 APIs

### 🎬 TMDB
- Movies and TV data — free with attribution
- Rate limit: 40 requests / 10 seconds
- [Documentation](https://developers.themoviedb.org/3)

### 🌸 AniList
- Anime data — free, no key required
- Rate limit: 90 requests / minute
- [Documentation](https://anilist.gitbook.io/anilist-apiv2-docs/)

---

## 📦 Dependencies

```yaml
provider: ^6.1.1
hive: ^2.2.3
hive_flutter: ^1.1.0
http: ^1.1.0
share_plus: ^7.2.1
flutter_local_notifications: ^16.3.0
cached_network_image: ^3.3.0
intl: ^0.18.1
shimmer: ^3.0.0
```

---

## 🔒 Privacy

- No accounts, no cloud sync, no analytics
- All favorites and lists stored locally on device 📱
- API calls go only to TMDB and AniList for public release data
- Shareable links contain IDs only — no personal data is transmitted

---

## 📱 Platform Support

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- 🔔 Notification permissions required on first launch

---
