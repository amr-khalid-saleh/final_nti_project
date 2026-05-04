import 'package:dartz/dartz.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/core/storage/secure_storage_service.dart';
import 'package:musix/features/auth/data/data_sources/auth_remote_data_source.dart';

abstract class AuthRepository {
  String getAuthorizationUrl();
  Future<Either<Failure, void>> exchangeCodeForToken(String code);
  Future<bool> checkSession();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SecureStorageService secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  });

  @override
  String getAuthorizationUrl() {
    return remoteDataSource.getAuthorizationUrl();
  }

  @override
  Future<Either<Failure, void>> exchangeCodeForToken(String code) async {
    try {
      final tokenModel = await remoteDataSource.exchangeCodeForToken(code);
      
      await secureStorage.saveAccessToken(tokenModel.accessToken);
      if (tokenModel.refreshToken != null) {
        await secureStorage.saveRefreshToken(tokenModel.refreshToken!);
      }
      
      return const Right(null);
    } on Failure catch (failure) {
      return Left(failure);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> checkSession() async {
    final token = await secureStorage.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> logout() async {
    await secureStorage.clearAll();
  }
}
