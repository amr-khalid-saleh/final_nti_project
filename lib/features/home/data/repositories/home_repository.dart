import 'package:dartz/dartz.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/features/home/data/data_sources/home_remote_data_source.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<TrackModel>>> getRecentlyPlayedTracks();
  Future<Either<Failure, List<TrackModel>>> getTopTracks();
  Future<Either<Failure, List<PlaylistModel>>> getFeaturedPlaylists();
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<TrackModel>>> getRecentlyPlayedTracks() async {
    try {
      final tracks = await remoteDataSource.getRecentlyPlayedTracks();
      return Right(tracks);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TrackModel>>> getTopTracks() async {
    try {
      final tracks = await remoteDataSource.getTopTracks();
      return Right(tracks);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PlaylistModel>>> getFeaturedPlaylists() async {
    try {
      final playlists = await remoteDataSource.getFeaturedPlaylists();
      return Right(playlists);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

