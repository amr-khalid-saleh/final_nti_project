import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/core/utils/app_routes.dart';
import 'package:musix/features/now_playing/controller/now_playing_cubit.dart';

/// Call this from any screen when the user taps a track tile.
///
/// It sets the track on the global NowPlayingCubit and navigates to
/// the Now Playing screen. The MiniPlayer automatically reflects the
/// new track because it listens to the same singleton cubit.
void playTrackAndNavigate(BuildContext context, TrackModel track) {
  context.read<NowPlayingCubit>().playTrack(track);
  Navigator.pushNamed(context, AppRoutes.nowPlaying);
}
