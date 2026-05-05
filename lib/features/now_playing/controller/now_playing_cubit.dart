import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit() : super(NowPlayingLoaded());

  /// Called from any screen when user taps a track.
  /// Updates the global player state so NowPlayingScreen and MiniPlayer
  /// both reflect the selected track immediately.
  void playTrack(TrackModel track) {
    emit(NowPlayingLoaded(
      currentTrack: track,
      isPlaying: true,
      isShuffle: _currentShuffle,
      isRepeat: _currentRepeat,
      progress: 0.0,
    ));
  }

  bool get _currentShuffle =>
      state is NowPlayingLoaded ? (state as NowPlayingLoaded).isShuffle : false;

  bool get _currentRepeat =>
      state is NowPlayingLoaded ? (state as NowPlayingLoaded).isRepeat : false;

  void togglePlay() {
    if (state is NowPlayingLoaded) {
      final current = state as NowPlayingLoaded;
      emit(current.copyWith(isPlaying: !current.isPlaying));
    }
  }

  void toggleShuffle() {
    if (state is NowPlayingLoaded) {
      final current = state as NowPlayingLoaded;
      emit(current.copyWith(isShuffle: !current.isShuffle));
    }
  }

  void toggleRepeat() {
    if (state is NowPlayingLoaded) {
      final current = state as NowPlayingLoaded;
      emit(current.copyWith(isRepeat: !current.isRepeat));
    }
  }

  void seekTo(double value) {
    if (state is NowPlayingLoaded) {
      final current = state as NowPlayingLoaded;
      emit(current.copyWith(progress: value));
    }
  }

  void skipNext() {}
  void skipPrevious() {}
}
