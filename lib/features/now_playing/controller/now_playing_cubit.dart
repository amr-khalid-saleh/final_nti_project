import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_sdk/models/player_state.dart';
import '../../../core/models/spotify_models.dart';
import '../../../core/services/spotify_player_service.dart';
import 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  final SpotifyPlayerService _player = SpotifyPlayerService();
  StreamSubscription<PlayerState?>? _playerStateSubscription;

  NowPlayingCubit() : super(NowPlayingLoaded());

  // ── Public API ────────────────────────────────────────────────────────────

  /// Called from any screen when the user taps a track.
  /// Connects to Spotify App Remote and starts playing immediately.
  Future<void> playTrack(TrackModel track) async {
    // Immediately emit the track so the UI updates (art, title, artist)
    emit(NowPlayingLoaded(
      currentTrack: track,
      isPlaying: true,
      sdkConnected: false,
    ));

    // Connect and play — if Spotify app is not installed, sdkConnected stays false
    final connected = await _player.connect();
    if (connected) {
      await _player.play(track.uri);
      _subscribeToPlayerState(track);
      final current = state as NowPlayingLoaded;
      emit(current.copyWith(sdkConnected: true, isPlaying: true));
    }
    // If not connected, UI still shows track metadata but playback falls back to Spotify deep link
  }

  Future<void> togglePlay() async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    if (current.sdkConnected) {
      if (current.isPlaying) {
        await _player.pause();
      } else {
        await _player.resume();
      }
    }
    emit(current.copyWith(isPlaying: !current.isPlaying));
  }

  Future<void> skipNext() async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    if (current.sdkConnected) await _player.skipNext();
  }

  Future<void> skipPrevious() async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    if (current.sdkConnected) await _player.skipPrevious();
  }

  Future<void> toggleShuffle() async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    final newValue = !current.isShuffle;
    if (current.sdkConnected) await _player.setShuffle(enabled: newValue);
    emit(current.copyWith(isShuffle: newValue));
  }

  Future<void> toggleRepeat() async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    final newValue = !current.isRepeat;
    if (current.sdkConnected) await _player.setRepeat(enabled: newValue);
    emit(current.copyWith(isRepeat: newValue));
  }

  Future<void> seekTo(double value) async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    emit(current.copyWith(progress: value));
    if (current.sdkConnected && current.currentTrack != null) {
      final positionMs = (value * current.currentTrack!.durationMs).toInt();
      await _player.seekTo(positionMs);
    }
  }

  // ── Private helpers ───────────────────────────────────────────────────────

  void _subscribeToPlayerState(TrackModel track) {
    _playerStateSubscription?.cancel();
    _playerStateSubscription = _player.playerStateStream.listen((playerState) {
      if (playerState == null || state is! NowPlayingLoaded) return;
      final current = state as NowPlayingLoaded;
      final durationMs = playerState.track?.duration ?? track.durationMs;
      final positionMs = playerState.playbackPosition;
      final progress =
          durationMs > 0 ? (positionMs / durationMs).clamp(0.0, 1.0) : 0.0;

      emit(current.copyWith(
        isPlaying: !playerState.isPaused,
        progress: progress,
        sdkConnected: true,
      ));
    });
  }

  @override
  Future<void> close() {
    _playerStateSubscription?.cancel();
    return super.close();
  }
}
