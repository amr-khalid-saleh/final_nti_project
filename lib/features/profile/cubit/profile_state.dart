import 'package:equatable/equatable.dart';
import 'package:musix/features/profile/data/models/user_profile_model.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfileModel profile;
  final List<TrackModel> recentTracks;

  const ProfileLoaded({
    required this.profile,
    required this.recentTracks,
  });

  @override
  List<Object?> get props => [profile, recentTracks];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}
