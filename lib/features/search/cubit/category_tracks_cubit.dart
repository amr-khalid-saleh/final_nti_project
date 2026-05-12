import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/features/search/data/repositories/search_repository.dart';
import 'category_tracks_state.dart';

class CategoryTracksCubit extends Cubit<CategoryTracksState> {
  final SearchRepository repository;

  CategoryTracksCubit({required this.repository}) : super(CategoryTracksInitial());

  Future<void> fetchCategoryTracks(String categoryId) async {
    emit(CategoryTracksLoading());

    final result = await repository.getCategoryTracks(categoryId);

    result.fold(
      (failure) => emit(CategoryTracksError(failure.message)),
      (tracks) => emit(CategoryTracksLoaded(tracks: tracks)),
    );
  }
}
