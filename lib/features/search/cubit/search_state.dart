import 'package:equatable/equatable.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchInitialDataLoaded extends SearchState {
  final List<CategoryModel> categories;
  final List<ArtistModel> trendingArtists;
  final List<AlbumModel> discoverAlbums;

  const SearchInitialDataLoaded({
    required this.categories,
    required this.trendingArtists,
    required this.discoverAlbums,
  });

  @override
  List<Object?> get props => [categories, trendingArtists, discoverAlbums];
}

class SearchResultsLoaded extends SearchState {
  final List<TrackModel> tracks;

  const SearchResultsLoaded({required this.tracks});

  @override
  List<Object?> get props => [tracks];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
