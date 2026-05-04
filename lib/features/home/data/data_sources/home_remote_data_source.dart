import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class HomeRemoteDataSource {
  Future<List<TrackModel>> getRecentlyPlayedTracks();
  Future<List<TrackModel>> getTopTracks();
  Future<List<PlaylistModel>> getFeaturedPlaylists();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TrackModel>> getRecentlyPlayedTracks() async {
    try {
      final response = await dio.get('/me/player/recently-played', queryParameters: {'limit': 10});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => TrackModel.fromJson(e['track'])).toList();
      } else {
        throw const ServerFailure('Failed to fetch recently played tracks');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<TrackModel>> getTopTracks() async {
    try {
      final response = await dio.get('/me/top/tracks', queryParameters: {'limit': 5});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => TrackModel.fromJson(e)).toList();
      } else {
        throw const ServerFailure('Failed to fetch top tracks');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<PlaylistModel>> getFeaturedPlaylists() async {
    try {
      final response = await dio.get('/browse/featured-playlists', queryParameters: {'limit': 4});
      if (response.statusCode == 200) {
        final items = response.data['playlists']['items'] as List;
        return items.map((e) => PlaylistModel.fromJson(e)).toList();
      } else {
        throw const ServerFailure('Failed to fetch featured playlists');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

