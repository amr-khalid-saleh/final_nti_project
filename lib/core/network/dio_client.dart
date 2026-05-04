import 'package:dio/dio.dart';
import 'package:musix/core/constants/spotify_constants.dart';
import 'package:musix/core/network/auth_interceptor.dart';
import 'package:musix/core/storage/secure_storage_service.dart';

class DioClient {
  late final Dio dio;

  DioClient(SecureStorageService secureStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.spotifyBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.add(AuthInterceptor(secureStorage, dio));
    
    // Add logging in debug mode
    dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }
}
