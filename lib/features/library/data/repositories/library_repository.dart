import 'package:dartz/dartz.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/features/library/data/data_sources/library_remote_data_source.dart';

abstract class LibraryRepository {
  Future<Either<Failure, List<PlaylistModel>>> getUserPlaylists();
  Future<Either<Failure, List<ArtistModel>>> getArtists();
  Future<Either<Failure, List<AlbumModel>>> getSavedAlbums();
  Future<Either<Failure, AlbumModel>> getAlbumById(String albumId);
  Future<Either<Failure, List<TrackModel>>> getArtistTopTracks(String artistId);
  Future<Either<Failure, List<AlbumModel>>> getArtistAlbums(String artistId);
}

class LibraryRepositoryImpl implements LibraryRepository {
  final LibraryRemoteDataSource remoteDataSource;

  LibraryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PlaylistModel>>> getUserPlaylists() async {
    try {
      final data = await remoteDataSource.getUserPlaylists();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ArtistModel>>> getArtists() async {
    try {
      final data = await remoteDataSource.getArtists();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AlbumModel>>> getSavedAlbums() async {
    try {
      final data = await remoteDataSource.getSavedAlbums();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AlbumModel>> getAlbumById(String albumId) async {
    try {
      final data = await remoteDataSource.getAlbumById(albumId);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TrackModel>>> getArtistTopTracks(String artistId) async {
    try {
      final data = await remoteDataSource.getArtistTopTracks(artistId);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AlbumModel>>> getArtistAlbums(String artistId) async {
    try {
      final data = await remoteDataSource.getArtistAlbums(artistId);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
