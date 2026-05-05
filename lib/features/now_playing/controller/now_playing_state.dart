import 'package:musix/core/models/spotify_models.dart';

abstract class NowPlayingState {}

class NowPlayingInitial extends NowPlayingState {}

class NowPlayingLoaded extends NowPlayingState {
  final TrackModel? currentTrack;
  final bool isPlaying;
  final bool isShuffle;
  final bool isRepeat;
  final Duration position;    // Real playback position from just_audio
  final Duration duration;    // Real track duration (preview = up to 30s)
  final bool hasPreview;      // false when track has no preview_url

  NowPlayingLoaded({
    this.currentTrack,
    this.isPlaying = false,
    this.isShuffle = false,
    this.isRepeat = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.hasPreview = true,
  });

  /// 0.0 → 1.0 progress for slider
  double get progress {
    if (duration.inMilliseconds == 0) return 0.0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  String get positionLabel => _formatDuration(position);
  String get durationLabel => _formatDuration(duration);

  String _formatDuration(Duration d) {
    final m = d.inMinutes;
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  NowPlayingLoaded copyWith({
    TrackModel? currentTrack,
    bool? isPlaying,
    bool? isShuffle,
    bool? isRepeat,
    Duration? position,
    Duration? duration,
    bool? hasPreview,
  }) {
    return NowPlayingLoaded(
      currentTrack: currentTrack ?? this.currentTrack,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      hasPreview: hasPreview ?? this.hasPreview,
    );
  }
}
