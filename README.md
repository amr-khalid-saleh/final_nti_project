# Musix - Music Streaming App

A modern music streaming mobile application built with Flutter, featuring high-fidelity audio playback, personalized recommendations, and a sleek dark-themed UI.

## 📱 Screenshots

The app includes the following screens:
- **Splash Screen** - Brand introduction
- **Onboarding** - Welcome flow with curated mood selection
- **Authentication** - Login and Sign up screens
- **Home** - Discover trending artists, albums, and playlists
- **Search** - Browse categories and find music
- **Library** - Your saved songs, playlists, and albums
- **Now Playing** - Full-screen player with controls
- **Artist Profile** - Artist details with discography
- **Profile** - User settings and preferences

## 🎨 Design Features

- **Dark Theme** with orange/coral accents
- **Modern UI/UX** with smooth animations
- **Card-based layouts** for music content
- **Bottom navigation** for easy access
- **Floating action buttons** for quick actions
- **Album artwork** with gradient overlays

## 📁 Project Structure

```
lib/
├── core/
│   ├── utils/             # Utility functions and helpers
│   ├── shared_widgets/    # Reusable UI components
│   └── theming/           # App theme and colors
│
│
├── features/                  # Feature modules
│       ├── auth/
│       │   ├── controller/    # Authentication logic
│       │   ├── data/          # Auth data models/repositories
│       │   └── presentation/
│       │       ├── screens/   # Login, Signup screens
│       │       └── widgets/   # Auth-specific widgets
│       ├── home/
│       │   ├── controller/
│       │   ├── data/
│       │   └── presentation/
│       │       ├── screens/   # Home screen
│       │       └── widgets/   # Home widgets
│       ├── library/
│       │   └── presentation/  # Library/collection screens
│       ├── onboarding/
│       │   └── presentation/  # Welcome/onboarding flow
│       ├── profile/
│       │   └── presentation/  # User profile and settings
│       └── search/
│           └── presentation/  # Search and browse screens
```

## 🏗️ Architecture

This project follows **Clean Architecture** with **Feature-First** organization:

- **`core/`** - Shared utilities, widgets, and theming
  - `utils/` - Helper functions and constants
  - `shared_widgets/` - Reusable components (buttons, cards, etc.)
  - `theming/` - App-wide theme configuration

- **`features/`** - Feature modules with separation of concerns
  - `controller/` - Business logic and state management
  - `data/` - Models, repositories, data sources
  - `presentation/` - UI layer (screens and widgets)

## ✨ Key Features

### 🎵 Music Playback
- High-fidelity audio streaming
- Now playing screen with album artwork
- Playback controls (play, pause, next, previous)
- Progress bar and track duration

### 🔍 Discovery
- Browse by categories (Electronic, Rock, Jazz, etc.)
- Trending artists and albums
- Personalized recommendations
- Recently played tracks

### 📚 Library Management
- Save favorite songs
- Create and manage playlists
- Follow artists
- Album collections

### 👤 User Features
- User authentication (login/signup)
- Profile customization
- Recent activity tracking
- Settings and preferences

### 🎨 UI/UX
- Dark theme optimized for music apps
- Smooth page transitions
- Bottom sheet modals
- Gesture controls

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK (>=2.17.0)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/amr-khalid-saleh/musix_app.git
cd musix_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **State Management**: [Bloc]
- **Architecture**: Clean Architecture + Feature-First
- **UI**: Material Design with custom theming

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  # Add your actual dependencies here
```

## 🎯 Features Roadmap

- [ ] Offline playback
- [ ] Lyrics integration
- [ ] Social sharing
- [ ] Audio equalizer
- [ ] Sleep timer
- [ ] Crossfade transitions
- [ ] Podcast support

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## 👥 Authors

- **Amr Saleh** - [GitHub Profile](https://github.com/amr-khalid-saleh)

## 🙏 Acknowledgments

- Design inspiration from Stitch ai for UI generator



