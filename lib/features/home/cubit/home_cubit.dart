import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/features/home/cubit/home_state.dart';
import 'package:musix/features/home/data/repositories/home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());

    final recentlyPlayedResult = await repository.getRecentlyPlayedTracks();
    final newReleasesResult = await repository.getNewReleases();
    final topTracksResult = await repository.getTopTracks();
    final featuredResult = await repository.getFeaturedPlaylists();

    // Recently played is essential — if it fails, show error
    recentlyPlayedResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (recentlyPlayed) {
        // All other sections degrade gracefully
        final specialDeal = newReleasesResult.fold(
          (_) => <AlbumModel>[],
          (data) => data,
        );
        final topTracks = topTracksResult.fold(
          (_) => <TrackModel>[],
          (data) => data,
        );
        final playlists = featuredResult.fold(
          (_) => <PlaylistModel>[],
          (data) => data,
        );

        emit(HomeLoaded(
          recentlyPlayed: recentlyPlayed,
          specialDealAlbums: specialDeal,
          topTracks: topTracks,
          featuredPlaylists: playlists,
        ));
      },
    );
  }
}
