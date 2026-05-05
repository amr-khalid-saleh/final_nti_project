import 'dart:async';
import 'package:just_audio/just_audio.dart';

/// In-app audio player powered by just_audio.
///
/// Plays Spotify's 30-second preview_url for each track.
/// This is the legal, official way to play audio in a Flutter app
/// that uses the Spotify Web API.
class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _player = AudioPlayer();

  // ── Streams for UI binding ─────────────────────────────────────────────────

  /// Emits the current playback position as a Duration.
  Stream<Duration> get positionStream => _player.positionStream;

  /// Emits the total duration once the source is loaded.
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Emits true while the player is actively playing.
  Stream<bool> get playingStream => _player.playingStream;

  /// Emits the current player state (loading, buffering, playing, etc.)
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  bool get isPlaying => _player.playing;

  // ── Playback control ───────────────────────────────────────────────────────

  /// Load and auto-play a Spotify preview URL.
  /// Returns false if the track has no preview URL.
  Future<bool> playPreview(String? previewUrl) async {
    if (previewUrl == null || previewUrl.isEmpty) return false;
    try {
      await _player.setUrl(previewUrl);
      await _player.play();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> play() async => _player.play();
  Future<void> pause() async => _player.pause();

  Future<void> seek(Duration position) async => _player.seek(position);

  Future<void> skipNext() async {
    // Preview-only: no queue, so seek to end / do nothing
    await _player.seek(_player.duration ?? Duration.zero);
    await _player.pause();
  }

  Future<void> skipPrevious() async {
    await _player.seek(Duration.zero);
    await _player.play();
  }

  void dispose() => _player.dispose();
}
