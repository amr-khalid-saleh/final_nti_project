import 'package:flutter_bloc/flutter_bloc.dart';
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
        final artists = artistsResult.fold((_) => <dynamic>[], (data) => data);
        final albums = albumsResult.fold((_) => <dynamic>[], (data) => data);

        emit(SearchInitialDataLoaded(
          categories: categories,
          trendingArtists: List.from(artists),
          discoverAlbums: List.from(albums),
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
      (tracks) => emit(SearchResultsLoaded(tracks: tracks)),
    );
  }
}
