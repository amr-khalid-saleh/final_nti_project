import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class LibraryRemoteDataSource {
  Future<List<PlaylistModel>> getUserPlaylists();
  Future<List<ArtistModel>> getArtists();
  Future<List<AlbumModel>> getSavedAlbums();
  Future<AlbumModel> getAlbumById(String albumId);
  Future<List<TrackModel>> getArtistTopTracks(String artistId);
  Future<List<AlbumModel>> getArtistAlbums(String artistId);
}

class LibraryRemoteDataSourceImpl implements LibraryRemoteDataSource {
  final Dio dio;

  LibraryRemoteDataSourceImpl({required this.dio});

  /// Playlists tab — user's owned + followed playlists.
  /// Falls back to Spotify featured playlists if the account has none.
  @override
  Future<List<PlaylistModel>> getUserPlaylists() async {
    try {
      final response = await dio.get('/me/playlists', queryParameters: {'limit': 50});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        final playlists = items.map((e) => PlaylistModel.fromJson(e)).toList();
        if (playlists.isNotEmpty) return playlists;
        // Empty account — return featured playlists as discovery content
        return _getFeaturedPlaylistsFallback();
      }
      throw const ServerFailure('Failed to fetch user playlists');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<List<PlaylistModel>> _getFeaturedPlaylistsFallback() async {
    try {
      final response = await dio.get('/browse/featured-playlists', queryParameters: {'limit': 20});
      if (response.statusCode == 200) {
        final items = response.data['playlists']['items'] as List;
        return items.map((e) => PlaylistModel.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
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
  /// Falls back to albums from recently-played tracks if the user has none saved.
  @override
  Future<List<AlbumModel>> getSavedAlbums() async {
    try {
      final response = await dio.get('/me/albums', queryParameters: {
        'limit': 50,
        'market': 'EG',
      });
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        final albums =
            items.map((e) => AlbumModel.fromJson(e['album'])).toList();
        if (albums.isNotEmpty) return albums;
        // User has no saved albums — pull from recently played instead
        return _getRecentlyPlayedAlbums();
      }
      throw const ServerFailure('Failed to fetch saved albums');
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) return _getRecentlyPlayedAlbums();
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  /// Extracts unique albums from /me/player/recently-played.
  Future<List<AlbumModel>> _getRecentlyPlayedAlbums() async {
    try {
      final response = await dio.get(
        '/me/player/recently-played',
        queryParameters: {'limit': 50},
      );
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        final seen = <String>{};
        final albums = <AlbumModel>[];
        for (final item in items) {
          final albumJson = item['track']?['album'] as Map<String, dynamic>?;
          if (albumJson == null) continue;
          final id = albumJson['id'] as String? ?? '';
          if (id.isNotEmpty && !seen.contains(id)) {
            seen.add(id);
            albums.add(AlbumModel.fromJson(albumJson));
          }
        }
        return albums;
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Fetch the full album object — includes tracklist with preview_url.
  /// Called by AlbumDetailsScreen when it receives a simplified album.
  @override
  Future<AlbumModel> getAlbumById(String albumId) async {
    try {
      final response = await dio.get(
        '/albums/$albumId',
      );
      if (response.statusCode == 200) {
        return AlbumModel.fromJson(response.data);
      }
      throw const ServerFailure('Failed to fetch album details');
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network Error');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<TrackModel>> getArtistTopTracks(String artistId) async {
    try {
      final response = await dio.get('/artists/$artistId/top-tracks', queryParameters: {'market': 'EG'});
      if (response.statusCode == 200) {
        final items = response.data['tracks'] as List;
        return items.map((e) => TrackModel.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  @override
  Future<List<AlbumModel>> getArtistAlbums(String artistId) async {
    try {
      final response = await dio.get('/artists/$artistId/albums', queryParameters: {'limit': 10});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => AlbumModel.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}
