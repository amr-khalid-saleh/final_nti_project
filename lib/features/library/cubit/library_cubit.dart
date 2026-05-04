import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/features/library/cubit/library_state.dart';
import 'package:musix/features/library/data/repositories/library_repository.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final LibraryRepository repository;

  LibraryCubit({required this.repository}) : super(LibraryInitial());

  Future<void> fetchLibraryData() async {
    emit(LibraryLoading());

    final playlistsResult = await repository.getUserPlaylists();
    final tracksResult = await repository.getSavedTracks();
    final artistsResult = await repository.getFollowedArtists();
    final albumsResult = await repository.getSavedAlbums();

    playlistsResult.fold(
      (failure) => emit(LibraryError(failure.message)),
      (playlists) {
        tracksResult.fold(
          (failure) => emit(LibraryError(failure.message)),
          (tracks) {
            artistsResult.fold(
              (failure) => emit(LibraryError(failure.message)),
              (artists) {
                albumsResult.fold(
                  (failure) => emit(LibraryError(failure.message)),
                  (albums) => emit(LibraryLoaded(
                    playlists: playlists,
                    savedTracks: tracks,
                    followedArtists: artists,
                    savedAlbums: albums,
                  )),
                );
              },
            );
          },
        );
      },
    );
  }
}
