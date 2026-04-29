abstract class NowPlayingState {}

class NowPlayingInitial extends NowPlayingState {}

class NowPlayingLoaded extends NowPlayingState {
  final bool isPlaying;
  final bool isShuffle;
  final bool isRepeat;
  final double progress; // 0.0 to 1.0

  NowPlayingLoaded({
    this.isPlaying = true,
    this.isShuffle = false,
    this.isRepeat = false,
    this.progress = 0.45,
  });

  NowPlayingLoaded copyWith({
    bool? isPlaying,
    bool? isShuffle,
    bool? isRepeat,
    double? progress,
  }) {
    return NowPlayingLoaded(
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
      progress: progress ?? this.progress,
    );
  }
}
