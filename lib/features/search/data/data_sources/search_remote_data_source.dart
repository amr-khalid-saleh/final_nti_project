import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class SearchRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ArtistModel>> getTrendingArtists();
  Future<List<AlbumModel>> getDiscoverAlbums();
  Future<List<TrackModel>> searchTracks(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/browse/categories', queryParameters: {'limit': 10});
      if (response.statusCode == 200) {
        final items = response.data['categories']['items'] as List;
        return items.map((e) => CategoryModel.fromJson(e)).toList();
      }
      throw const ServerFailure('Failed to fetch categories');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ArtistModel>> getTrendingArtists() async {
    try {
      final response = await dio.get('/me/top/artists', queryParameters: {'limit': 5});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => ArtistModel.fromJson(e)).toList();
      }
      throw const ServerFailure('Failed to fetch trending artists');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<AlbumModel>> getDiscoverAlbums() async {
    try {
      final response = await dio.get('/browse/new-releases', queryParameters: {'limit': 5});
      if (response.statusCode == 200) {
        final items = response.data['albums']['items'] as List;
        return items.map((e) => AlbumModel.fromJson(e)).toList();
      }
      throw const ServerFailure('Failed to fetch discover albums');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<TrackModel>> searchTracks(String query) async {
    try {
      final response = await dio.get('/search', queryParameters: {
        'q': query,
        'type': 'track',
        'limit': 20,
      });
      if (response.statusCode == 200) {
        final items = response.data['tracks']['items'] as List;
        return items.map((e) => TrackModel.fromJson(e)).toList();
      }
      throw const ServerFailure('Failed to fetch search results');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

