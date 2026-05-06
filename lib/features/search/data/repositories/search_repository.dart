import 'package:dartz/dartz.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';
import 'package:musix/features/search/data/data_sources/search_remote_data_source.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<CategoryModel>>> getCategories();
  Future<Either<Failure, List<ArtistModel>>> getTrendingArtists();
  Future<Either<Failure, List<AlbumModel>>> getDiscoverAlbums();
  Future<Either<Failure, List<TrackModel>>> searchTracks(String query);
  Future<Either<Failure, SearchResultsModel>> searchItems(String query);
}

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CategoryModel>>> getCategories() async {
    try {
      final data = await remoteDataSource.getCategories();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ArtistModel>>> getTrendingArtists() async {
    try {
      final data = await remoteDataSource.getTrendingArtists();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AlbumModel>>> getDiscoverAlbums() async {
    try {
      final data = await remoteDataSource.getDiscoverAlbums();
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TrackModel>>> searchTracks(String query) async {
    try {
      final data = await remoteDataSource.searchTracks(query);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }


  @override
  Future<Either<Failure, SearchResultsModel>> searchItems(String query) async {
    try {
      final data = await remoteDataSource.searchItems(query);
      return Right(data);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
