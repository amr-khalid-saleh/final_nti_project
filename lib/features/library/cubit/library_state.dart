import 'package:equatable/equatable.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<PlaylistModel> playlists;
  final List<ArtistModel> artists;
  final List<AlbumModel> savedAlbums;

  const LibraryLoaded({
    required this.playlists,
    required this.artists,
    required this.savedAlbums,
  });

  @override
  List<Object?> get props => [playlists, artists, savedAlbums];
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError(this.message);

  @override
  List<Object?> get props => [message];
}
