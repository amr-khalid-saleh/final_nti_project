import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/features/home/cubit/home_state.dart';
import 'package:musix/features/home/data/repositories/home_repository.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(HomeInitial());

  Future<void> fetchHomeData() async {
    emit(HomeLoading());

    final recentlyPlayedResult = await repository.getRecentlyPlayedTracks();
    final topTracksResult = await repository.getTopTracks();
    final featuredResult = await repository.getFeaturedPlaylists();

    recentlyPlayedResult.fold(
      (failure) => emit(HomeError(failure.message)),
      (recentlyPlayed) {
        topTracksResult.fold(
          (failure) => emit(HomeError(failure.message)),
          (topTracks) {
            featuredResult.fold(
              (failure) => emit(HomeError(failure.message)),
              (playlists) => emit(HomeLoaded(
                recentlyPlayed: recentlyPlayed,
                topTracks: topTracks,
                featuredPlaylists: playlists,
              )),
            );
          },
        );
      },
    );
  }
}
