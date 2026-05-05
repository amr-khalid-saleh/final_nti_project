import 'package:musix/core/models/spotify_models.dart';

abstract class NowPlayingState {}

class NowPlayingInitial extends NowPlayingState {}

class NowPlayingLoaded extends NowPlayingState {
  final TrackModel? currentTrack;
  final bool isPlaying;
  final bool isShuffle;
  final bool isRepeat;
  final double progress; // 0.0 to 1.0

  NowPlayingLoaded({
    this.currentTrack,
    this.isPlaying = true,
    this.isShuffle = false,
    this.isRepeat = false,
    this.progress = 0.0,
  });

  NowPlayingLoaded copyWith({
    TrackModel? currentTrack,
    bool? isPlaying,
    bool? isShuffle,
    bool? isRepeat,
    double? progress,
  }) {
    return NowPlayingLoaded(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
      progress: progress ?? this.progress,
    );
  }
}
