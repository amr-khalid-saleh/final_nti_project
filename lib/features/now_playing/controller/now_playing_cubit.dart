import 'package:flutter_bloc/flutter_bloc.dart';
import 'now_playing_state.dart';

class NowPlayingCubit extends Cubit<NowPlayingState> {
  NowPlayingCubit() : super(NowPlayingLoaded());

  void togglePlay() {
    final current = state as NowPlayingLoaded;
    emit(current.copyWith(isPlaying: !current.isPlaying));
  }

  void toggleShuffle() {
    final current = state as NowPlayingLoaded;
    emit(current.copyWith(isShuffle: !current.isShuffle));
  }

  void toggleRepeat() {
    final current = state as NowPlayingLoaded;
    emit(current.copyWith(isRepeat: !current.isRepeat));
  }

  void seekTo(double value) {
    final current = state as NowPlayingLoaded;
    emit(current.copyWith(progress: value));
  }

  // TODO: skipNext / skipPrevious — connect to API later
  void skipNext() {}
  void skipPrevious() {}
}
