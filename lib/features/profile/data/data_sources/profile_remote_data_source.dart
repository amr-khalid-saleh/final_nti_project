import 'package:dio/dio.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/features/profile/data/models/user_profile_model.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getCurrentUserProfile();
  Future<List<TrackModel>> getRecentlyPlayedTracks();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserProfileModel> getCurrentUserProfile() async {
    try {
      final profileRes = await dio.get('/me');
      
      int followingCount = 0;
      int playlistCount = 0;

      if (profileRes.statusCode == 200) {
        try {
          final followingRes = await dio.get('/me/following?type=artist');
          if (followingRes.statusCode == 200) {
            followingCount = followingRes.data['artists']?['total'] ?? 0;
          }
        } catch (_) {}

        try {
          final playlistRes = await dio.get('/me/playlists');
          if (playlistRes.statusCode == 200) {
            playlistCount = playlistRes.data['total'] ?? 0;
          }
        } catch (_) {}

        final profile = UserProfileModel.fromJson(profileRes.data);
        return profile.copyWith(
          followingCount: followingCount,
          playlistCount: playlistCount,
        );
      }
      throw const ServerFailure('Failed to fetch user profile');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<List<TrackModel>> getRecentlyPlayedTracks() async {
    try {
      final response = await dio.get('/me/player/recently-played', queryParameters: {'limit': 5});
      if (response.statusCode == 200) {
        final items = response.data['items'] as List;
        return items.map((e) => TrackModel.fromJson(e['track'])).toList();
      }
      throw const ServerFailure('Failed to fetch recently played tracks');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}

