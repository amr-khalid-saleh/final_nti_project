import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class SearchRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ArtistModel>> getTrendingArtists();
  Future<List<AlbumModel>> getDiscoverAlbums();
  Future<List<TrackModel>> searchTracks(String query);
  Future<SearchResultsModel> searchItems(String query);
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/browse/categories', queryParameters: {
        'limit': 10,
        'country': 'EG',
      });
      if (response.statusCode == 200) {
        final items = response.data['categories']['items'] as List;
        return items.map((e) => CategoryModel.fromJson(e)).toList();
      }
      return _getFallbackCategories();
    } catch (e) {
      // If 403 Forbidden, use fallback curated categories
      return _getFallbackCategories();
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
      return []; // Graceful fallback
    } on DioException catch (e) {
      // 403 = insufficient scope, return empty instead of crashing
      if (e.response?.statusCode == 403) return [];
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<AlbumModel>> getDiscoverAlbums() async {
    try {
      // Try search API for "new releases" if browse is restricted
      final response = await dio.get('/search', queryParameters: {
        'q': 'tag:new',
        'type': 'album',
        'limit': 5,
      });
      if (response.statusCode == 200) {
        final items = response.data['albums']['items'] as List;
        return items.map((e) => AlbumModel.fromJson(e)).toList();
      }
      return []; // Graceful fallback
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) return [];
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      return [];
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
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<SearchResultsModel> searchItems(String query) async {
    try {
      final response = await dio.get('/search', queryParameters: {
        'q': query,
        'type': 'track,artist,album',
        'limit': 20,
        'market': 'EG',
      });

      if (response.statusCode == 200) {
        return SearchResultsModel.fromJson(response.data);
      }

      throw const ServerFailure('Failed to fetch search results');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  List<CategoryModel> _getFallbackCategories() {
    return [
      CategoryModel(
        id: 'toplists',
        name: 'Top Lists',
        icons: [ImageModel(url: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=274&q=80')],
      ),
      CategoryModel(
        id: 'pop',
        name: 'Pop',
        icons: [ImageModel(url: 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?auto=format&fit=crop&w=274&q=80')],
      ),
      CategoryModel(
        id: 'hiphop',
        name: 'Hip Hop',
        icons: [ImageModel(url: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?auto=format&fit=crop&w=274&q=80')],
      ),
      CategoryModel(
        id: 'workout',
        name: 'Workout',
        icons: [ImageModel(url: 'https://images.unsplash.com/photo-1534258936925-c58bed479fcb?auto=format&fit=crop&w=274&q=80')],
      ),
      CategoryModel(
        id: 'chill',
        name: 'Chill',
        icons: [ImageModel(url: 'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?auto=format&fit=crop&w=274&q=80')],
      ),
      CategoryModel(
        id: 'mood',
        name: 'Mood',
        icons: [ImageModel(url: 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?auto=format&fit=crop&w=274&q=80')],
      ),
    ];
  }
}

