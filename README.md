# Musix 🎵

Musix is a modern, dynamic Flutter music streaming application built as a graduation project. It serves as a fully functional frontend client integrated seamlessly with the **Spotify Web API**, transforming static UI mockups into a rich, data-driven experience. 

The primary goal of this project is to demonstrate advanced Flutter architectural patterns, secure third-party authentication (OAuth 2.0 with PKCE), and complex state management by integrating real-time Spotify user data.

---

## 🛠 Tech Stack

- **Framework**: Flutter / Dart
- **State Management**: `flutter_bloc` (Cubit implementation)
- **Networking**: `dio` (with custom interceptors for token injection and refresh)
- **Dependency Injection**: `get_it`
- **Authentication**: Spotify Web API via Authorization Code Flow with PKCE (`app_links` for deep linking)
- **Local Storage**: `flutter_secure_storage` (for secure token persistence)
- **Architecture**: Feature-based Domain-Driven Design (DDD-lite)

---

## 🏛 Architecture Overview

The application follows a clean, feature-first architectural pattern ensuring scalability, separation of concerns, and maintainability:

1. **Core Layer (`lib/core/`)**: Houses shared utilities, constants, network clients, secure storage services, error handling (`failures.dart`), and global dependency injection configuration.
2. **Feature Layer (`lib/features/`)**: Divided into independent modules (`auth`, `home`, `search`, `library`, `profile`). Each feature strictly contains:
   - **Data**: `models`, `data_sources` (remote API calls), and `repositories` (error handling and data mapping).
   - **Cubit**: State management orchestrating logic between the UI and repositories.
   - **Presentation**: `screens` and `widgets` specifically mapped to Cubit states via `BlocBuilder`.

### Folder Structure
```text
lib/
├── core/
│   ├── constants/
│   ├── error/
│   ├── injection/
│   ├── models/           # Shared Spotify API models (Track, Album, etc.)
│   ├── network/          # Dio client and Auth Interceptor
│   ├── shared_widgets/
│   ├── storage/
│   └── theming/
└── features/
    ├── auth/             # PKCE Flow, Login, Token Management
    ├── home/             # Recently Played, Top Tracks, Featured Playlists
    ├── search/           # Browse Categories, Discover, Live Querying
    ├── library/          # User Playlists, Saved Albums, Followed Artists
    └── profile/          # User Stats, Premium Tier, Recent Activity
```

---

## ✨ Implemented Features

- **Authentication 🔐**: Full implementation of Spotify's Authorization Code Flow with PKCE. Securely exchanges authorization codes for access and refresh tokens without embedding client secrets in the mobile client.
- **Home Feed 🏠**: Dynamic fetching and rendering of the user's `Recently Played Tracks`, `Top Tracks`, and `Featured Playlists`.
- **Search & Discovery 🔍**: 
  - Initial load presents real Spotify `Categories`, `Trending Artists`, and `New Releases`.
  - Active search bar allows live querying of tracks.
- **User Library 📚**: Dedicated tabs fetching the authenticated user's `Playlists`, followed `Artists`, and saved `Albums`. Features dynamic track counts.
- **Profile 👤**: Displays the user's real Spotify avatar, display name, follower count, Premium/Free subscription tier, and recent listening activity.
- **Current Playback Status**: *UI foundations and API connections are complete. Raw audio streaming (Spotify App Remote) is pending implementation in future iterations.*

---

## 🔐 Authentication Setup & Flow

This application uses the **Authorization Code with PKCE** flow, the recommended OAuth 2.0 standard for public clients (like mobile apps) to prevent authorization code interception attacks.

1. The app generates a cryptographically secure `code_verifier` and `code_challenge`.
2. The user is redirected to the Spotify Accounts authorization URL.
3. Upon approval, Spotify redirects back to the app via a custom scheme (`com.amoorsaleh.musix://callback`).
4. The `AuthInterceptor` automatically attaches the token to subsequent Dio requests and handles 401 Unauthorized errors by silently refreshing the token.

---

## ⚙️ Platform Configuration

### Android Setup
The `AndroidManifest.xml` is configured to intercept the custom redirect URI:
```xml
<intent-filter>
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="com.amoorsaleh.musix" android:host="callback" />
</intent-filter>
```

### iOS Setup
The `Info.plist` is configured for URL schemes:
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

## 🚀 Getting Started

### Prerequisites
1. A Spotify Developer Account.
2. A registered app on the [Spotify Developer Dashboard](https://developer.spotify.com/dashboard).
3. Set the Redirect URI in the dashboard to exactly: `com.amoorsaleh.musix://callback`

### Installation
1. Clone the repository.
2. Run `flutter pub get` to install dependencies.
3. Open `lib/core/constants/spotify_constants.dart` and verify the `clientId` matches your Spotify Developer App client ID. (Note: It is safe to expose the client ID in public clients; the client secret is intentionally omitted).
4. Run the app on a physical device or emulator using `flutter run`.

---

## ⚠️ Known Limitations

- **Playback Constraints**: Full track streaming directly within a third-party mobile app requires the official Spotify app to be installed on the device (utilizing the Spotify App Remote SDK). Currently, the app maps all UI and data layers but does not trigger raw audio playback.
- **Free Account Restrictions**: Some Spotify API endpoints and App Remote features are strictly limited to Spotify Premium subscribers.
- **Pagination**: Large libraries (playlists > 50 items) currently load the first page of results. Infinite scrolling/pagination is not fully implemented.

---

## 🔮 Future Improvements

1. **Playback Integration**: Bind track taps to trigger Spotify App Remote or Web API playback state modifications.
2. **Pagination Strategy**: Implement infinite scrolling `Bloc` logic for the Library and Search result views.
3. **Local Caching**: Persist API responses using Hive or SQLite to reduce network calls and improve initial load times.
4. **Recommendations Engine**: Utilize Spotify's seed-based recommendation endpoints to power a "Made For You" view.
