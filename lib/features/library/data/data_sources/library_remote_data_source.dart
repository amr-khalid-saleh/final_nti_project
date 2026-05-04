import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class LibraryRemoteDataSource {
  Future<List<PlaylistModel>> getUserPlaylists();
  Future<List<TrackModel>> getSavedTracks();
  Future<List<ArtistModel>> getFollowedArtists();
  Future<List<AlbumModel>> getSavedAlbums();
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  final Dio dio;

  LibraryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PlaylistModel>> getUserPlaylists() async {
    try {
      final response = await dio.get('/me/playlists', queryParameters: {'limit': 50});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => PlaylistModel.fromJson(e)).toList();
      }
      throw const ServerFailure('Failed to fetch user playlists');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<TrackModel>> getSavedTracks() async {
    try {
      final response = await dio.get('/me/tracks', queryParameters: {'limit': 50});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => TrackModel.fromJson(e['track'])).toList();
      }
      throw const ServerFailure('Failed to fetch saved tracks');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<ArtistModel>> getFollowedArtists() async {
    try {
      final response = await dio.get('/me/following', queryParameters: {'type': 'artist', 'limit': 50});
      if (response.statusCode == 200) {
        final items = response.data['artists']['items'] as List;
        return items.map((e) => ArtistModel.fromJson(e)).toList();
      }
      throw const ServerFailure('Failed to fetch followed artists');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<AlbumModel>> getSavedAlbums() async {
    try {
      final response = await dio.get('/me/albums', queryParameters: {'limit': 50});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => AlbumModel.fromJson(e['album'])).toList();
      }
      throw const ServerFailure('Failed to fetch saved albums');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
