# Musix — Spotify-Powered Music App (NTI Final Project)

A Flutter graduation project built for NTI that integrates the **Spotify Web API** and **Spotify App Remote SDK** to deliver a full music browsing and streaming experience on mobile. Musix supports authentication via PKCE, real-time music discovery, library management, and a robust global playback state layer synchronized with the Spotify App.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| UI | Flutter (Dart) |
| State management | `flutter_bloc` — Cubit pattern |
| Networking | `Dio` with authenticated interceptors |
| Dependency injection | `GetIt` |
| Secure storage | `flutter_secure_storage` |
| Auth flow | Spotify PKCE (no client secret in app) |
| API | Spotify Web API v1 |
| Deep linking | Android Intent / iOS URL scheme |
| Screen sizing | `flutter_screenutil` |

---

## Architecture

Musix follows a **feature-first clean architecture** with three consistent layers inside every feature:

```
feature/
├── cubit/          # State management (Cubit + State classes)
├── data/
│   ├── data_sources/   # Remote API calls (Dio)
│   └── repositories/   # Either<Failure, T> wrapping
└── presentation/
    ├── screens/
    └── widgets/
```

### Core layer (`lib/core/`)

```
core/
├── constants/       # Spotify credentials, scopes, base URLs
├── error/           # Failure types
├── injection/       # GetIt dependency registration
├── models/          # Shared Spotify models (TrackModel, AlbumModel, etc.)
├── network/         # DioClient + AuthInterceptor (token inject + refresh)
├── shared_widgets/  # MainScaffold, AppMiniPlayer, AppBottomNavBar
├── storage/         # SecureStorageService
├── theming/         # AppColors, AppTextStyles
└── utils/           # AppRouter, AppRoutes, player_utils
```

---

## Folder Structure

```
lib/
├── core/
│   ├── constants/spotify_constants.dart
│   ├── error/failures.dart
│   ├── injection/injection_container.dart
│   ├── models/spotify_models.dart
│   ├── network/
│   │   ├── auth_interceptor.dart
│   │   └── dio_client.dart
│   ├── shared_widgets/
│   │   ├── app_bottom_nav_bar.dart
│   │   ├── app_mini_player.dart
│   │   └── main_scaffold.dart
│   ├── storage/secure_storage_service.dart
│   ├── theming/
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   └── utils/
│       ├── app_router.dart
│       ├── app_routes.dart
│       └── player_utils.dart
├── features/
│   ├── auth/
│   ├── home/
│   ├── library/
│   ├── now_playing/
│   ├── onboarding/
│   ├── profile/
│   ├── search/
│   └── splash/
└── main.dart
```

---

## Implemented Features

### Authentication
- Spotify PKCE authorization code flow
- Secure token storage (access + refresh tokens)
- Automatic token refresh via Dio interceptor
- Session restore on app launch (splash screen checks stored token)
- Deep link callback handling for auth redirect

### Home
| Section | Spotify Endpoint | Notes |
|---------|-----------------|-------|
| Speed Dial | `GET /me/player/recently-played` | Recently played tracks with album art |
| Special Deal | `GET /browse/new-releases` | New album releases — falls back to `/search?q=tag:new` on 403 |
| Trending Now | `GET /me/top/tracks` | User's top tracks (best available proxy for trending) |
| Fresh Finds | `GET /me/playlists` | User's own playlists |

### Search
| Section | Spotify Endpoint | Notes |
|---------|-----------------|-------|
| Categories | `GET /browse/categories` | With curated local fallback on 403 |
| Trending Artists | `GET /me/top/artists` | User's top artists — no official trending endpoint exists |
| Discover Albums | `GET /search?q=tag:new&type=album` | New album discovery |
| Search results | `GET /search?q={query}&type=track` | Live track search |

### Library
| Tab | Spotify Endpoint | Notes |
|-----|-----------------|-------|
| Playlists | `GET /me/playlists` | User's playlists |
| Artists | `GET /me/following?type=artist` | Falls back to `/me/top/artists` on 403 |
| Albums | `GET /me/albums` | User's saved albums |

### Now Playing & Playback
- Global `NowPlayingCubit` singleton shared across all screens
- Full **Spotify App Remote** integration using `spotify_sdk` for real in-app playback
- Any track tap from Home, Search, Library, or detail screens invokes `playTrack()` and seamlessly plays in the background
- Now Playing screen displays real album art, title, artist, and formatted duration
- **Real-time Sync**: The UI dynamically updates and stays in sync even if songs are skipped or auto-played directly inside the Spotify app
- MiniPlayer auto-shows on all main screens once a track is selected
- Swipe-down gesture to dismiss Now Playing view

### Profile
- User display name, email, follower count
- Dynamic counts for **Following** and **Playlists**
- Subscription type (Free / Premium)
- Recent listening activity

---

## Authentication Setup

Musix uses the **Spotify Authorization Code Flow with PKCE** — no client secret is stored in the app.

### Steps to configure

1. Go to [Spotify Developer Dashboard](https://developer.spotify.com/dashboard)
2. Create an app and note your **Client ID**
3. Add `com.amoorsaleh.musix://callback` as a **Redirect URI**
4. Open `lib/core/constants/spotify_constants.dart` and set:

```dart
static const String clientId = 'YOUR_CLIENT_ID';
static const String redirectUri = 'com.amoorsaleh.musix://callback';
```

### Required scopes

```dart
'user-read-private'
'user-read-email'
'user-library-read'
'user-top-read'
'playlist-read-private'
'playlist-read-collaborative'
'user-read-recently-played'
'user-modify-playback-state'
'user-read-playback-state'
'user-follow-read'
```

> **Note**: `user-follow-read` requires re-authentication if the token was issued before it was added. The app handles the 403 gracefully by falling back to top artists.

---

## Platform Configuration

### Android

`android/app/src/main/AndroidManifest.xml` includes an intent filter for the redirect URI:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="com.amoorsaleh.musix" android:host="callback" />
</intent-filter>
```

### iOS

`ios/Runner/Info.plist` includes the URL scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>com.amoorsaleh.musix</string>
    </array>
  </dict>
</array>
```

---

## Getting Started

```bash
# 1. Clone the repo
git clone https://github.com/your-username/musix_app.git
cd musix_app

# 2. Install dependencies
flutter pub get

# 3. Set your Spotify Client ID
# Edit lib/core/constants/spotify_constants.dart

# 4. Run on a connected device
flutter run
```

> Requires Flutter 3.x and a physical/emulated device with internet access.

---

## Known Limitations

| Limitation | Detail |
|-----------|--------|
| **Premium Account Required** | Spotify's mobile SDK (`spotify_sdk`) requires the Spotify app to be installed and the user to have a **Premium** account for playback control. |
| **Browse endpoints may return 403** | `/browse/categories` and `/browse/new-releases` can be restricted depending on the Spotify app's market configuration. All affected endpoints have local fallbacks. |
| **`/me/following` requires re-auth** | If the token was issued before `user-follow-read` was added to scopes, the Artists tab falls back to top artists silently. |
| **No pagination** | All list endpoints use a fixed `limit` (20–50 items). Infinite scroll / pagination is not implemented. |
| **No offline support** | All data is fetched live. No local caching layer is in place. |

---


## Project Context

Musix is a **Flutter final graduation project for NTI** built to demonstrate:
- Real-world API integration with proper auth (PKCE, OAuth2)
- Complex Spotify App Remote SDK integration for seamless background audio streaming
- Clean architecture with feature separation
- Resilient error handling for restricted API scopes
- Global state management for shared playback context
- Professional Flutter project structure suitable for production
