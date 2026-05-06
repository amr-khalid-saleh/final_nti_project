import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotify_sdk/models/player_state.dart' as sp;
import '../constants/spotify_constants.dart';

/// Controls playback through the Spotify app running in the background.
///
/// The user stays in Musix at all times — Spotify runs silently behind.
/// Requires the Spotify app to be installed on the device.
class SpotifyPlayerService {
  static final SpotifyPlayerService _instance =
      SpotifyPlayerService._internal();
  factory SpotifyPlayerService() => _instance;
  SpotifyPlayerService._internal();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  // ── Connection ─────────────────────────────────────────────────────────────

  /// Connect to the Spotify app via App Remote.
  /// Returns true if connected successfully.
  Future<bool> connect() async {
    if (_isConnected) return true;
    try {
      final result = await SpotifySdk.connectToSpotifyRemote(
        clientId: ApiConstants.clientId,
        redirectUrl: ApiConstants.redirectUri,
      );
      _isConnected = result;
      debugPrint('[SpotifyPlayer] Connected: $result');
      return result;
    } catch (e) {
      debugPrint('[SpotifyPlayer] Connection failed: $e');
      _isConnected = false;
      return false;
    }
  }

  // ── Playback control ───────────────────────────────────────────────────────

  /// Play a Spotify URI (e.g. "spotify:track:xxx").
  Future<void> play(String spotifyUri) async {
    try {
      await SpotifySdk.play(spotifyUri: spotifyUri);
      debugPrint('[SpotifyPlayer] Playing: $spotifyUri');
    } catch (e) {
      debugPrint('[SpotifyPlayer] Play failed: $e');
    }
  }

  Future<void> pause() async {
    try {
      await SpotifySdk.pause();
    } catch (e) {
      debugPrint('[SpotifyPlayer] Pause failed: $e');
    }
  }

  Future<void> resume() async {
    try {
      await SpotifySdk.resume();
    } catch (e) {
      debugPrint('[SpotifyPlayer] Resume failed: $e');
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } catch (e) {
      debugPrint('[SpotifyPlayer] Skip next failed: $e');
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } catch (e) {
      debugPrint('[SpotifyPlayer] Skip previous failed: $e');
    }
  }

  Future<void> seekTo(int positionMs) async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: positionMs);
    } catch (e) {
      debugPrint('[SpotifyPlayer] Seek failed: $e');
    }
  }

  // ── Player state stream ────────────────────────────────────────────────────

  /// Live stream of Spotify player state (track, position, paused, etc.)
  Stream<sp.PlayerState> get playerStateStream {
    return SpotifySdk.subscribePlayerState();
  }

  /// Get current player state snapshot.
  Future<sp.PlayerState?> getPlayerState() async {
    try {
      return await SpotifySdk.getPlayerState();
    } catch (e) {
      debugPrint('[SpotifyPlayer] Get state failed: $e');
      return null;
    }
  }

  void disconnect() {
    try {
      SpotifySdk.disconnect();
      _isConnected = false;
    } catch (_) {}
  }
}
