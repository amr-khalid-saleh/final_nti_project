import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_sdk/models/player_state.dart' as sp;
import '../../../core/models/spotify_models.dart';
import '../../../core/services/spotify_player_service.dart';
import 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  final SpotifyPlayerService _player = SpotifyPlayerService();
  StreamSubscription<sp.PlayerState>? _playerStateSub;
  Timer? _positionTimer;

  NowPlayingCubit() : super(NowPlayingLoaded());

  // ── Public API ────────────────────────────────────────────────────────────

  /// Called when user taps a track anywhere in the app.
  /// Connects to Spotify App Remote (if not yet), then plays the track.
  Future<void> playTrack(TrackModel track) async {
    // Show track metadata immediately
    emit(NowPlayingLoaded(
      currentTrack: track,
      isPlaying: true,
      durationMs: track.durationMs,
      positionMs: 0,
      isConnected: _player.isConnected,
    ));

    // Connect if not already
    if (!_player.isConnected) {
      final connected = await _player.connect();
      if (!connected) {
        debugPrint('[NowPlaying] Failed to connect to Spotify app');
        if (state is NowPlayingLoaded) {
          emit((state as NowPlayingLoaded).copyWith(
            isConnected: false,
            isPlaying: false,
          ));
        }
        return;
      }
    }

    // Play via Spotify App Remote
    await _player.play(track.uri);

    // Subscribe to player state updates
    _subscribeToState(track);

    // Start position polling (Spotify SDK doesn't stream position continuously)
    _startPositionPolling();

    if (state is NowPlayingLoaded) {
      emit((state as NowPlayingLoaded).copyWith(
        isConnected: true,
        isPlaying: true,
      ));
    }
  }

  Future<void> togglePlay() async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    if (!current.isConnected) return;

    if (current.isPlaying) {
      await _player.pause();
    } else {
      await _player.resume();
    }
    emit(current.copyWith(isPlaying: !current.isPlaying));
  }

  Future<void> skipNext() async {
    if (state is! NowPlayingLoaded) return;
    if (!(state as NowPlayingLoaded).isConnected) return;
    await _player.skipNext();
  }

  Future<void> skipPrevious() async {
    if (state is! NowPlayingLoaded) return;
    if (!(state as NowPlayingLoaded).isConnected) return;
    await _player.skipPrevious();
  }

  Future<void> toggleShuffle() async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    emit(current.copyWith(isShuffle: !current.isShuffle));
  }

  Future<void> toggleRepeat() async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    emit(current.copyWith(isRepeat: !current.isRepeat));
  }

  /// Seek to a position (0.0 - 1.0 value from slider)
  Future<void> seekTo(double value) async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    if (!current.isConnected) return;
    final targetMs = (value * current.durationMs).toInt();
    await _player.seekTo(targetMs);
    emit(current.copyWith(positionMs: targetMs));
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _subscribeToState(TrackModel track) {
    _playerStateSub?.cancel();
    try {
      _playerStateSub = _player.playerStateStream.listen(
        (playerState) {
          if (state is! NowPlayingLoaded) return;
          final current = state as NowPlayingLoaded;

          final duration =
              playerState.track?.duration ?? track.durationMs;
          final position = playerState.playbackPosition;

          emit(current.copyWith(
            isPlaying: !playerState.isPaused,
            positionMs: position,
            durationMs: duration,
            isConnected: true,
          ));
        },
        onError: (e) {
          debugPrint('[NowPlaying] Player state stream error: $e');
        },
      );
    } catch (e) {
      debugPrint('[NowPlaying] Failed to subscribe: $e');
    }
  }

  /// Poll position every second since Spotify SDK doesn't stream position
  /// continuously — it only fires on state changes (play/pause/skip).
  void _startPositionPolling() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (state is! NowPlayingLoaded) return;
      final current = state as NowPlayingLoaded;
      if (!current.isPlaying || !current.isConnected) return;

      // Increment position locally for smooth UI
      final newPos = current.positionMs + 1000;
      if (newPos <= current.durationMs) {
        emit(current.copyWith(positionMs: newPos));
      }
    });
  }

  @override
  Future<void> close() {
    _playerStateSub?.cancel();
    _positionTimer?.cancel();
    return super.close();
  }
}
