import 'package:equatable/equatable.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class ArtistDetailsState extends Equatable {
  const ArtistDetailsState();

  @override
  List<Object?> get props => [];
}

class ArtistDetailsInitial extends ArtistDetailsState {
  const ArtistDetailsInitial();
}

class ArtistDetailsLoading extends ArtistDetailsState {
  final ArtistModel? initialArtist;

  const ArtistDetailsLoading({this.initialArtist});

  @override
  List<Object?> get props => [initialArtist];
}

class ArtistDetailsLoaded extends ArtistDetailsState {
  final ArtistModel artist;
  final List<TrackModel> topTracks;
  final List<AlbumModel> albums;

  const ArtistDetailsLoaded({
    required this.artist,
    required this.topTracks,
    required this.albums,
  });

  @override
  List<Object?> get props => [artist, topTracks, albums];
}

class ArtistDetailsError extends ArtistDetailsState {
  final String message;
  final ArtistModel? initialArtist;

  const ArtistDetailsError({required this.message, this.initialArtist});

  @override
  List<Object?> get props => [message, initialArtist];
}
