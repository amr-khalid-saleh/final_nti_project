import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/features/library/cubit/artist_details_state.dart';
import 'package:musix/features/library/data/repositories/artist_details_repository.dart';

class ArtistDetailsCubit extends Cubit<ArtistDetailsState> {
  final ArtistDetailsRepository repository;

  ArtistDetailsCubit({required this.repository})
      : super(const ArtistDetailsInitial());

  Future<void> fetchArtistDetails(ArtistModel initialArtist) async {
    if (initialArtist.id.isEmpty) {
      emit(
        ArtistDetailsError(
          message: 'Artist id is missing. Please try another artist.',
          initialArtist: initialArtist,
        ),
      );
      return;
    }

    emit(ArtistDetailsLoading(initialArtist: initialArtist));

    final artistResult = await repository.getArtist(initialArtist.id);

    await artistResult.fold(
      (failure) async => emit(
        ArtistDetailsError(
          message: failure.message,
          initialArtist: initialArtist,
        ),
      ),
      (artist) async {
        final tracksResult = await repository.getArtistTopTracks(artist.id);
        final albumsResult = await repository.getArtistAlbums(artist.id);

        final topTracks = tracksResult.fold(
          (_) => <TrackModel>[],
          (tracks) => tracks,
        );

        final albums = albumsResult.fold(
          (_) => <AlbumModel>[],
          (items) => items,
        );

        final secondaryFailure = _getSecondaryFailure(
          tracksFailure: tracksResult.fold((failure) => failure, (_) => null),
          albumsFailure: albumsResult.fold((failure) => failure, (_) => null),
        );

        if (secondaryFailure != null && topTracks.isEmpty && albums.isEmpty) {
          emit(
            ArtistDetailsError(
              message: secondaryFailure.message,
              initialArtist: artist,
            ),
          );
          return;
        }

        emit(
          ArtistDetailsLoaded(
            artist: artist,
            topTracks: topTracks,
            albums: albums,
          ),
        );
      },
    );
  }

  Failure? _getSecondaryFailure({
    required Failure? tracksFailure,
    required Failure? albumsFailure,
  }) {
    return tracksFailure ?? albumsFailure;
  }
}
