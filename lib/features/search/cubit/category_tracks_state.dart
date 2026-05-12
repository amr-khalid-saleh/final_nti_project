import 'package:equatable/equatable.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class CategoryTracksState extends Equatable {
  const CategoryTracksState();

  @override
  List<Object?> get props => [];
}

class CategoryTracksInitial extends CategoryTracksState {}

class CategoryTracksLoading extends CategoryTracksState {}

class CategoryTracksLoaded extends CategoryTracksState {
  final List<TrackModel> tracks;

  const CategoryTracksLoaded({required this.tracks});

  @override
  List<Object?> get props => [tracks];
}

class CategoryTracksError extends CategoryTracksState {
  final String message;

  const CategoryTracksError(this.message);

  @override
  List<Object?> get props => [message];
}
