import 'package:equatable/equatable.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<TrackModel> recentlyPlayed;
  final List<AlbumModel> specialDealAlbums;
  final List<TrackModel> topTracks;
  final List<PlaylistModel> featuredPlaylists;

  const HomeLoaded({
    required this.recentlyPlayed,
    required this.specialDealAlbums,
    required this.topTracks,
    required this.featuredPlaylists,
  });

  @override
  List<Object?> get props => [recentlyPlayed, specialDealAlbums, topTracks, featuredPlaylists];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
