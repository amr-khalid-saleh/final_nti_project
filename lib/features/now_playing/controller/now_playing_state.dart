import 'package:musix/core/models/spotify_models.dart';

abstract class NowPlayingState {}

class NowPlayingInitial extends NowPlayingState {}

class NowPlayingLoaded extends NowPlayingState {
  final TrackModel? currentTrack;
  final bool isPlaying;
  final bool isShuffle;
  final bool isRepeat;
  final int positionMs;     // Current playback position in milliseconds
  final int durationMs;     // Track duration in milliseconds
  final bool isConnected;   // true when Spotify App Remote is connected

  NowPlayingLoaded({
    this.currentTrack,
    this.isPlaying = false,
    this.isShuffle = false,
    this.isRepeat = false,
    this.positionMs = 0,
    this.durationMs = 0,
    this.isConnected = false,
  });

  /// 0.0 → 1.0 progress for slider
  double get progress {
    if (durationMs == 0) return 0.0;
    return (positionMs / durationMs).clamp(0.0, 1.0);
  }

  String get positionLabel => _formatMs(positionMs);
  String get durationLabel => _formatMs(durationMs);

  String _formatMs(int ms) {
    final totalSeconds = ms ~/ 1000;
    final m = totalSeconds ~/ 60;
    final s = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  NowPlayingLoaded copyWith({
    TrackModel? currentTrack,
    bool? isPlaying,
    bool? isShuffle,
    bool? isRepeat,
    int? positionMs,
    int? durationMs,
    bool? isConnected,
  }) {
    return NowPlayingLoaded(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
      positionMs: positionMs ?? this.positionMs,
      durationMs: durationMs ?? this.durationMs,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}
