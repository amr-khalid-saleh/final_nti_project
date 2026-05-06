import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class ArtistDetailsRemoteDataSource {
  Future<ArtistModel> getArtist(String artistId);
  Future<List<TrackModel>> getArtistTopTracks(String artistId);
  Future<List<AlbumModel>> getArtistAlbums(String artistId);
}

class ArtistDetailsRemoteDataSourceImpl
    implements ArtistDetailsRemoteDataSource {
  final Dio dio;

  ArtistDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<ArtistModel> getArtist(String artistId) async {
    try {
      final response = await dio.get('/artists/$artistId');

      if (response.statusCode == 200) {
        return ArtistModel.fromJson(response.data);
      }

      throw const ServerFailure('Failed to fetch artist details.');
    } on DioException catch (e) {
      throw ServerFailure(_getReadableDioError(e));
    } on ServerFailure {
      rethrow;
    } catch (_) {
      throw const ServerFailure(
        'Something went wrong while loading this artist. Please try again.',
      );
    }
  }

  @override
  Future<List<TrackModel>> getArtistTopTracks(String artistId) async {
    try {
      final response = await dio.get(
        '/artists/$artistId/top-tracks',
        queryParameters: {'market': 'EG'},
      );

      if (response.statusCode == 200) {
        final tracks = response.data['tracks'] as List? ?? [];
        return tracks.map((e) => TrackModel.fromJson(e)).toList();
      }

      throw const ServerFailure('Failed to fetch artist top tracks.');
    } on DioException catch (e) {
      throw ServerFailure(_getReadableDioError(e));
    } on ServerFailure {
      rethrow;
    } catch (_) {
      throw const ServerFailure(
        'Something went wrong while loading top tracks. Please try again.',
      );
    }
  }

  @override
  Future<List<AlbumModel>> getArtistAlbums(String artistId) async {
    try {
      final response = await dio.get(
        '/artists/$artistId/albums',
        queryParameters: {
          'include_groups': 'album,single',
          'market': 'EG',
          'limit': 20,
        },
      );

      if (response.statusCode == 200) {
        final albums = response.data['items'] as List? ?? [];
        return albums.map((e) => AlbumModel.fromJson(e)).toList();
      }

      throw const ServerFailure('Failed to fetch artist albums.');
    } on DioException catch (e) {
      throw ServerFailure(_getReadableDioError(e));
    } on ServerFailure {
      rethrow;
    } catch (_) {
      throw const ServerFailure(
        'Something went wrong while loading albums. Please try again.',
      );
    }
  }

  String _getReadableDioError(DioException error) {
    final statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      return 'Your Spotify session has expired. Please sign in again.';
    }

    if (statusCode == 403) {
      return 'Spotify refused this request. Please check your Spotify app access or login permissions.';
    }

    if (statusCode == 404) {
      return 'This artist could not be found on Spotify.';
    }

    if (statusCode == 429) {
      return 'Too many requests to Spotify. Please wait a moment and try again.';
    }

    if (statusCode != null && statusCode >= 500) {
      return 'Spotify service is currently unavailable. Please try again later.';
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet and try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network and try again.';
      case DioExceptionType.badCertificate:
        return 'Secure connection failed. Please try again later.';
      case DioExceptionType.cancel:
        return 'Artist details request was cancelled. Please try again.';
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return 'Could not load artist details. Please try again.';
    }
  }
}
