import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/models/spotify_models.dart';
import '../../../core/services/spotify_player_service.dart';
import 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  final AudioPlayerService _audio = AudioPlayerService();

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<bool>? _playingSub;

  NowPlayingCubit() : super(NowPlayingLoaded()) {
    _bindStreams();
  }

  // ── Stream binding ────────────────────────────────────────────────────────

  void _bindStreams() {
    _positionSub = _audio.positionStream.listen((pos) {
      if (state is NowPlayingLoaded) {
        emit((state as NowPlayingLoaded).copyWith(position: pos));
      }
    });

    _durationSub = _audio.durationStream.listen((dur) {
      if (dur != null && state is NowPlayingLoaded) {
        emit((state as NowPlayingLoaded).copyWith(duration: dur));
      }
    });

    _playingSub = _audio.playingStream.listen((playing) {
      if (state is NowPlayingLoaded) {
        emit((state as NowPlayingLoaded).copyWith(isPlaying: playing));
      }
    });
  }

  // ── Public API ────────────────────────────────────────────────────────────

  /// Play a track. Immediately shows metadata in the UI, then loads the
  /// preview audio. If the track has no preview_url, shows a notice.
  Future<void> playTrack(TrackModel track) async {
    // Reset position when switching tracks
    emit(NowPlayingLoaded(
      currentTrack: track,
      isPlaying: true,
      position: Duration.zero,
      duration: Duration.zero,
      hasPreview: track.previewUrl != null,
    ));

    final loaded = await _audio.playPreview(track.previewUrl);
    if (!loaded && state is NowPlayingLoaded) {
      // No preview URL — update flag so UI can show a notice
      emit((state as NowPlayingLoaded).copyWith(
        hasPreview: false,
        isPlaying: false,
      ));
    }
  }

  Future<void> togglePlay() async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    if (!current.hasPreview) return;
    if (current.isPlaying) {
      await _audio.pause();
    } else {
      await _audio.play();
    }
    // State will update via playingStream subscription
  }

  Future<void> skipNext() async {
    await _audio.skipNext();
  }

  Future<void> skipPrevious() async {
    await _audio.skipPrevious();
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

  /// Called when the user drags the slider.
  Future<void> seekTo(double value) async {
    if (state is! NowPlayingLoaded) return;
    final current = state as NowPlayingLoaded;
    if (!current.hasPreview) return;
    final targetMs =
        (value * current.duration.inMilliseconds).toInt();
    await _audio.seek(Duration(milliseconds: targetMs));
  }

  @override
  Future<void> close() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playingSub?.cancel();
    return super.close();
  }
}
