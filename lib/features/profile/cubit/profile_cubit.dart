import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musix/features/profile/cubit/profile_state.dart';
import 'package:musix/features/profile/data/repositories/profile_repository.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository repository;

  ProfileCubit({required this.repository}) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    emit(ProfileLoading());

    final profileResult = await repository.getCurrentUserProfile();
    final tracksResult = await repository.getRecentlyPlayedTracks();

    profileResult.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) {
        tracksResult.fold(
          (failure) => emit(ProfileError(failure.message)),
          (tracks) => emit(ProfileLoaded(profile: profile, recentTracks: tracks)),
        );
      },
    );
  }
}

