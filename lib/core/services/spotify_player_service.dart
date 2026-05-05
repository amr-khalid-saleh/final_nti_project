import 'dart:async';
import 'package:flutter/services.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import '../constants/spotify_constants.dart';

/// Wraps spotify_sdk (Spotify App Remote) for in-app playback control.
///
/// Requirements:
/// - Spotify app must be installed on the device
/// - User must have Spotify Premium for uninterrupted playback
///   (Free users can play but Spotify may shuffle or override)
class SpotifyPlayerService {
  static final SpotifyPlayerService _instance =
      SpotifyPlayerService._internal();
  factory SpotifyPlayerService() => _instance;
  SpotifyPlayerService._internal();

  bool _connected = false;
  bool get isConnected => _connected;

  /// Connect to the Spotify App Remote.
  /// Call this when the user first taps play or enters NowPlayingScreen.
  Future<bool> connect() async {
    if (_connected) return true;
    try {
      _connected = await SpotifySdk.connectToSpotifyRemote(
        clientId: ApiConstants.clientId,
        redirectUrl: ApiConstants.redirectUri,
      );
      return _connected;
    } on PlatformException catch (e) {
      // Spotify app not installed or auth failed
      _connected = false;
      return false;
    } catch (e) {
      _connected = false;
      return false;
    }
  }

  /// Play a track by Spotify URI (e.g. "spotify:track:xxxx").
  Future<void> play(String spotifyUri) async {
    if (!_connected) await connect();
    if (!_connected) return;
    try {
      await SpotifySdk.play(spotifyUri: spotifyUri);
    } on PlatformException {
      _connected = false;
    }
  }

  Future<void> pause() async {
    if (!_connected) return;
    try {
      await SpotifySdk.pause();
    } on PlatformException {
      _connected = false;
    }
  }

  Future<void> resume() async {
    if (!_connected) return;
    try {
      await SpotifySdk.resume();
    } on PlatformException {
      _connected = false;
    }
  }

  Future<void> skipNext() async {
    if (!_connected) return;
    try {
      await SpotifySdk.skipNext();
    } on PlatformException {
      _connected = false;
    }
  }

  Future<void> skipPrevious() async {
    if (!_connected) return;
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException {
      _connected = false;
    }
  }

  Future<void> seekTo(int positionMs) async {
    if (!_connected) return;
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: positionMs);
    } on PlatformException {
      _connected = false;
    }
  }

  Future<void> setShuffle({required bool enabled}) async {
    if (!_connected) return;
    try {
      await SpotifySdk.setShuffle(shuffle: enabled);
    } on PlatformException {
      _connected = false;
    }
  }

  Future<void> setRepeat({required bool enabled}) async {
    if (!_connected) return;
    try {
      await SpotifySdk.setRepeatMode(
        repeatMode: enabled ? RepeatMode.track : RepeatMode.off,
      );
    } on PlatformException {
      _connected = false;
    }
  }

  /// Live player state stream from Spotify App Remote.
  Stream<PlayerState?> get playerStateStream =>
      SpotifySdk.subscribePlayerState();

  void disconnect() {
    SpotifySdk.disconnectFromSpotifyRemote();
    _connected = false;
  }
}
