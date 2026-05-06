import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/features/search/data/repositories/search_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repository;

  SearchCubit({required this.repository}) : super(SearchInitial());

  Future<void> fetchInitialData() async {
    emit(SearchLoading());

    final categoriesResult = await repository.getCategories();
    final artistsResult = await repository.getTrendingArtists();
    final albumsResult = await repository.getDiscoverAlbums();

    // Categories are essential — if they fail, show error
    categoriesResult.fold(
      (failure) => emit(SearchError(failure.message)),
      (categories) {
        // Artists and albums are optional — degrade gracefully
        final artists = artistsResult.fold(
          (_) => <ArtistModel>[],
          (data) => data,
        );
        final albums = albumsResult.fold(
          (_) => <AlbumModel>[],
          (data) => data,
        );

        emit(SearchInitialDataLoaded(
          categories: categories,
          trendingArtists: artists,
          discoverAlbums: albums,
        ));
      },
    );
  }

  Future<void> searchTracks(String query) async {
    if (query.isEmpty) {
      // Re-fetch or simply revert to initial state. For simplicity, re-fetch.
      fetchInitialData();
      return;
    }

    emit(SearchLoading());
    final result = await repository.searchTracks(query);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (tracks) => emit(
        SearchResultsLoaded(
          tracks: tracks,
          artists: const [],
          albums: const [],
        ),
      ),
    );
  }

  Future<void> searchItems(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      fetchInitialData();
      return;
    }

    emit(SearchLoading());
    final result = await repository.searchItems(trimmedQuery);

    result.fold(
      (failure) => emit(SearchError(failure.message)),
      (results) => emit(
        SearchResultsLoaded(
          tracks: results.tracks,
          artists: results.artists,
          albums: results.albums,
        ),
      ),
    );
  }
}
