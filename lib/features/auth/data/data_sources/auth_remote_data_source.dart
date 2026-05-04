import 'package:dio/dio.dart';
import 'package:musix/core/constants/api_constants.dart';
import 'package:musix/core/error/failures.dart';
import 'package:musix/features/auth/data/models/token_model.dart';
import 'package:pkce/pkce.dart';

abstract class AuthRemoteDataSource {
  String getAuthorizationUrl();
  Future<TokenModel> exchangeCodeForToken(String code);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  late PkcePair _pkcePair;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  String getAuthorizationUrl() {
    _pkcePair = PkcePair.generate(length: 128); // Generates verifier and challenge
    
    final scopes = ApiConstants.scopes.join(' ');
    
    final authUrl = Uri.https('accounts.spotify.com', '/authorize', {
      'response_type': 'code',
      'client_id': ApiConstants.clientId,
      'redirect_uri': ApiConstants.redirectUri,
      'scope': scopes,
      'code_challenge_method': 'S256',
      'code_challenge': _pkcePair.codeChallenge,
    });
    
    return authUrl.toString();
  }

  @override
  Future<TokenModel> exchangeCodeForToken(String code) async {
    try {
      final response = await dio.post(
        '${ApiConstants.spotifyAccountsUrl}/api/token',
        options: Options(
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'client_id': ApiConstants.clientId,
          'grant_type': 'authorization_code',
          'code': code,
          'redirect_uri': ApiConstants.redirectUri,
          'code_verifier': _pkcePair.codeVerifier,
        },
      );

      if (response.statusCode == 200) {
        return TokenModel.fromJson(response.data);
      } else {
        throw const ServerFailure('Failed to exchange code for token');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Network error during authentication');
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
