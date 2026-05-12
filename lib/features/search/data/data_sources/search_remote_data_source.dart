import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class SearchRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ArtistModel>> getTrendingArtists();
  Future<List<AlbumModel>> getDiscoverAlbums();
  Future<List<TrackModel>> searchTracks(String query);
  Future<List<TrackModel>> getCategoryTracks(String categoryId);
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
      final response = await dio.get('/me/top/artists', queryParameters: {'limit': 10, 'time_range': 'medium_term'});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        final top = items.map((e) => ArtistModel.fromJson(e)).toList();
        // If top artists is thin (<3), supplement with recently-played track artists
        if (top.length < 3) {
          final extra = await _getRecentlyPlayedArtists();
          final seen = top.map((a) => a.id).toSet();
          for (final a in extra) {
            if (!seen.contains(a.id)) {
              seen.add(a.id);
              top.add(a);
            }
            if (top.length >= 10) break;
          }
        }
        return top;
      }
      return _getRecentlyPlayedArtists();
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) return _getRecentlyPlayedArtists();
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Extracts unique artists from /me/player/recently-played as a fallback source.
  Future<List<ArtistModel>> _getRecentlyPlayedArtists() async {
    try {
      final response = await dio.get('/me/player/recently-played', queryParameters: {'limit': 50});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        final seen = <String>{};
        final artists = <ArtistModel>[];
        for (final item in items) {
          final trackArtists = item['track']?['artists'] as List? ?? [];
          for (final a in trackArtists) {
            final id = a['id'] as String? ?? '';
            if (id.isNotEmpty && !seen.contains(id)) {
              seen.add(id);
              artists.add(ArtistModel.fromJson(a));
            }
          }
          if (artists.length >= 10) break;
        }
        return artists;
      }
      return [];
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
        'market': 'EG',
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
  Future<List<TrackModel>> getCategoryTracks(String categoryId) async {
    try {
      // Step 1: Get playlists for the category
      final response = await dio.get('/browse/categories/$categoryId/playlists',
          queryParameters: {'limit': 5, 'country': 'EG'});

      if (response.statusCode == 200) {
        final playlists = response.data['playlists']['items'] as List;
        if (playlists.isNotEmpty) {
          // Step 2: Get tracks from the first few playlists to build a list
          final allTracks = <TrackModel>[];
          for (var i = 0; i < (playlists.length > 3 ? 3 : playlists.length); i++) {
            final playlistId = playlists[i]['id'];
            final tracksResponse = await dio.get('/playlists/$playlistId/tracks',
                queryParameters: {'limit': 10});
            if (tracksResponse.statusCode == 200) {
              final items = tracksResponse.data['items'] as List;
              for (final item in items) {
                if (item['track'] != null) {
                  allTracks.add(TrackModel.fromJson(item['track']));
                }
              }
            }
          }
          // Remove duplicates and return
          final seen = <String>{};
          return allTracks.where((t) => seen.add(t.id)).toList();
        }
      }

      // Fallback: Search for category name as genre
      return searchTracks('genre:$categoryId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
         // Some categories might not have browseable playlists, try search
         return searchTracks('genre:$categoryId');
      }
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

