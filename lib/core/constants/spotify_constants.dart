class ApiConstants {
  static const String spotifyBaseUrl = 'https://api.spotify.com/v1';
  static const String spotifyAccountsUrl = 'https://accounts.spotify.com';
  
  // Provide your Spotify Client ID here.
  // Note: Client ID is safe to store in the app. Client Secret is NOT.
  static const String clientId = 'YOUR_SPOTIFY_CLIENT_ID'; // TODO: Replace with your actual Client ID
  
  // The redirect URI matching your Spotify Dashboard configuration
  static const String redirectUri = 'com.amoorsaleh.musix://callback';
  
  static const List<String> scopes = [
    'user-read-private',
    'user-read-email',
    'user-library-read',
    'user-top-read',
    'playlist-read-private',
    'playlist-read-collaborative',
    'user-read-recently-played',
    'user-modify-playback-state', // for App Remote / Playback
    'user-read-playback-state',
  ];
}
