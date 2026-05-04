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
      final response = await dio.get('/me');
      if (response.statusCode == 200) {
        return UserProfileModel.fromJson(response.data);
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

