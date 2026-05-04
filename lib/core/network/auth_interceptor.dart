import 'package:dio/dio.dart';
import 'package:musix/core/storage/secure_storage_service.dart';
import 'package:musix/core/constants/api_constants.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService secureStorage;
  final Dio dio;

  // Track if a refresh is currently in progress to avoid multiple rapid refresh calls
  bool _isRefreshing = false;

  AuthInterceptor(this.secureStorage, this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await secureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only attempt refresh if it's a 401 Unauthorized and we haven't already marked this request as a retry
    if (err.response?.statusCode == 401 && err.requestOptions.extra['isRetry'] != true) {
      if (_isRefreshing) {
        return handler.next(err); // Avoid infinite loops or overlapping refreshes
      }
      
      _isRefreshing = true;
      
      final refreshToken = await secureStorage.getRefreshToken();
      if (refreshToken != null) {
        final isRefreshed = await _refreshToken(refreshToken);
        
        _isRefreshing = false;

        if (isRefreshed) {
          // Update stored tokens
          final newToken = await secureStorage.getAccessToken();
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newToken';
          
          // Mark as a retry to prevent infinite loop on consecutive 401s
          opts.extra['isRetry'] = true;
          
          try {
            // Retry the original request exactly ONCE
            final cloneReq = await dio.request(
              opts.path,
              options: Options(
                method: opts.method,
                headers: opts.headers,
                extra: opts.extra,
              ),
              data: opts.data,
              queryParameters: opts.queryParameters,
            );
            return handler.resolve(cloneReq);
          } catch (e) {
            return handler.next(err);
          }
        }
      } else {
        _isRefreshing = false;
      }
    }
    return handler.next(err);
  }

  Future<bool> _refreshToken(String refreshToken) async {
    try {
      // Use a separate dio instance or standard http call to avoid interceptor loop
      final response = await Dio().post(
        '${ApiConstants.spotifyAccountsUrl}/api/token',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'grant_type': 'refresh_token',
          'refresh_token': refreshToken,
          'client_id': ApiConstants.clientId,
        },
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'] ?? refreshToken;
        
        await secureStorage.saveAccessToken(newAccessToken);
        await secureStorage.saveRefreshToken(newRefreshToken);
        return true;
      }
    } catch (e) {
      // If refresh fails permanently (e.g., revoked access), clear storage to force unauthenticated state
      await secureStorage.clearAll();
    }
    return false;
  }
}
