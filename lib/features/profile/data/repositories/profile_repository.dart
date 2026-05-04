import 'package:dartz/dartz.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/features/profile/data/data_sources/profile_remote_data_source.dart';
import 'package:musix/features/profile/data/models/user_profile_model.dart';
import 'package:musix/core/models/spotify_models.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileModel>> getCurrentUserProfile();
  Future<Either<Failure, List<TrackModel>>> getRecentlyPlayedTracks();
}

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfileModel>> getCurrentUserProfile() async {
    try {
      final profile = await remoteDataSource.getCurrentUserProfile();
      return Right(profile);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TrackModel>>> getRecentlyPlayedTracks() async {
    try {
      final tracks = await remoteDataSource.getRecentlyPlayedTracks();
      return Right(tracks);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

