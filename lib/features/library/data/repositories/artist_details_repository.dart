import 'package:dartz/dartz.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/features/library/data/data_sources/artist_details_remote_data_source.dart';

abstract class ArtistDetailsRepository {
  Future<Either<Failure, ArtistModel>> getArtist(String artistId);
  Future<Either<Failure, List<TrackModel>>> getArtistTopTracks(String artistId);
  Future<Either<Failure, List<AlbumModel>>> getArtistAlbums(String artistId);
}

class ArtistDetailsRepositoryImpl implements ArtistDetailsRepository {
  final ArtistDetailsRemoteDataSource remoteDataSource;

  ArtistDetailsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ArtistModel>> getArtist(String artistId) async {
    try {
      final artist = await remoteDataSource.getArtist(artistId);
      return Right(artist);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<TrackModel>>> getArtistTopTracks(
    String artistId,
  ) async {
    try {
      final tracks = await remoteDataSource.getArtistTopTracks(artistId);
      return Right(tracks);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<AlbumModel>>> getArtistAlbums(
    String artistId,
  ) async {
    try {
      final albums = await remoteDataSource.getArtistAlbums(artistId);
      return Right(albums);
    } catch (e) {
      return Left(_mapExceptionToFailure(e));
    }
  }

  Failure _mapExceptionToFailure(Object error) {
    if (error is Failure) {
      return error;
    }

    return const ServerFailure('Something went wrong. Please try again.');
  }
}
