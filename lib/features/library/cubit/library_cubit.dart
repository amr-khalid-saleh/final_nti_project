import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/features/library/cubit/library_state.dart';
import 'package:musix/features/library/data/repositories/library_repository.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LibraryRepository repository;

  LibraryCubit({required this.repository}) : super(LibraryInitial());

  Future<void> fetchLibraryData() async {
    emit(LibraryLoading());

    final playlistsResult = await repository.getUserPlaylists();
    final artistsResult = await repository.getArtists();
    final albumsResult = await repository.getSavedAlbums();

    // Playlists are essential — if they fail, show error
    playlistsResult.fold(
      (failure) => emit(LibraryError(failure.message)),
      (playlists) {
        // Artists and albums degrade gracefully
        final artists = artistsResult.fold(
          (_) => <ArtistModel>[],
          (data) => data,
        );
        final albums = albumsResult.fold(
          (_) => <AlbumModel>[],
          (data) => data,
        );

        emit(LibraryLoaded(
          playlists: playlists,
          artists: artists,
          savedAlbums: albums,
        ));
      },
    );
  }
}
