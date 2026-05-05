import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class LibraryRemoteDataSource {
  Future<List<PlaylistModel>> getUserPlaylists();
  Future<List<ArtistModel>> getArtists();
  Future<List<AlbumModel>> getSavedAlbums();
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  final Dio dio;

  LibraryRemoteDataSourceImpl({required this.dio});

  /// Playlists tab — user's own playlists.
  @override
  Future<List<PlaylistModel>> getUserPlaylists() async {
    try {
      final response = await dio.get('/me/playlists', queryParameters: {'limit': 50});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => PlaylistModel.fromJson(e)).toList();
      }
      throw const ServerFailure('Failed to fetch user playlists');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  /// Artists tab — tries followed artists first (requires user-follow-read scope).
  /// Falls back to top artists (/me/top/artists) on 403 "Insufficient client scope".
  /// This ensures the Artists tab always has content even without the follow scope.
  @override
  Future<List<ArtistModel>> getArtists() async {
    try {
      final response = await dio.get(
        '/me/following',
        queryParameters: {'type': 'artist', 'limit': 50},
      );
      if (response.statusCode == 200) {
        final items = response.data['artists']['items'] as List;
        return items.map((e) => ArtistModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // Insufficient scope — fall back to top artists
        return _getTopArtistsFallback();
      }
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      return [];
    }
  }

  Future<List<ArtistModel>> _getTopArtistsFallback() async {
    try {
      final response = await dio.get('/me/top/artists', queryParameters: {'limit': 20});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => ArtistModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Albums tab — user's saved albums.
  @override
  Future<List<AlbumModel>> getSavedAlbums() async {
    try {
      final response = await dio.get('/me/albums', queryParameters: {'limit': 50});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => AlbumModel.fromJson(e['album'])).toList();
      }
      throw const ServerFailure('Failed to fetch saved albums');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
