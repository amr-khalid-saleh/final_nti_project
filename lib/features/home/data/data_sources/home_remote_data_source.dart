import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class HomeRemoteDataSource {
  Future<List<TrackModel>> getRecentlyPlayedTracks();
  Future<List<AlbumModel>> getNewReleases();
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
      }
      throw const ServerFailure('Failed to fetch recently played tracks');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  /// "Special Deal" section — powered by Spotify new releases.
  /// Spotify has no direct "trending albums" endpoint.
  /// /browse/new-releases is the official album discovery endpoint.
  /// Falls back to /search?q=tag:new on 403 (restricted browse API).
  @override
  Future<List<AlbumModel>> getNewReleases() async {
    try {
      final response = await dio.get('/browse/new-releases', queryParameters: {'limit': 6});
      if (response.statusCode == 200) {
        final items = response.data['albums']['items'] as List;
        return items.map((e) => AlbumModel.fromJson(e)).toList();
      }
      return [];
    } on DioException catch (e) {
      // 403 = restricted browse API — fall back to search
      if (e.response?.statusCode == 403) {
        return _getNewReleasesViaSearch();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<AlbumModel>> _getNewReleasesViaSearch() async {
    try {
      final response = await dio.get('/search', queryParameters: {
        'q': 'tag:new',
        'type': 'album',
        'limit': 6,
      });
      if (response.statusCode == 200) {
        final items = response.data['albums']['items'] as List;
        return items.map((e) => AlbumModel.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// "Trending Now" section — powered by user's top tracks.
  /// Spotify has no official "trending tracks" endpoint.
  /// /me/top/tracks returns the user's most-listened tracks,
  /// which is the closest personalized proxy for "trending".
  @override
  Future<List<TrackModel>> getTopTracks() async {
    try {
      final response = await dio.get('/me/top/tracks', queryParameters: {'limit': 5});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => TrackModel.fromJson(e)).toList();
      }
      throw const ServerFailure('Failed to fetch top tracks');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  /// "Fresh Finds" section — powered by user's playlists.
  @override
  Future<List<PlaylistModel>> getFeaturedPlaylists() async {
    try {
      final response = await dio.get('/me/playlists', queryParameters: {'limit': 4});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => PlaylistModel.fromJson(e)).toList();
      }
      throw const ServerFailure('Failed to fetch playlists');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
