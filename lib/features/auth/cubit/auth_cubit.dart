import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_links/app_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:musix/features/auth/cubit/auth_state.dart';
import 'package:musix/features/auth/data/repositories/auth_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSubscription;

  AuthCubit({required this.repository}) : super(AuthInitial()) {
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _linkSubscription = _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.host == 'callback') {
        final code = uri.queryParameters['code'];
        if (code != null) {
          _handleAuthorizationCode(code);
        } else {
          emit(const AuthError('Authorization failed or was cancelled.'));
        }
      }
    }, onError: (err) {
      emit(AuthError('Deep link error: $err'));
    });
  }

  Future<void> checkSession() async {
    emit(AuthLoading());
    final hasSession = await repository.checkSession();
    if (hasSession) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> loginWithSpotify() async {
    try {
      emit(AuthLoading());
      final authUrl = repository.getAuthorizationUrl();
      final uri = Uri.parse(authUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        emit(const AuthError('Could not launch Spotify login page.'));
      }
    } catch (e) {
      emit(AuthError('Login initialization failed: $e'));
    }
  }

  Future<void> _handleAuthorizationCode(String code) async {
    emit(AuthLoading());
    final result = await repository.exchangeCodeForToken(code);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(Authenticated()),
    );
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await repository.logout();
    emit(Unauthenticated());
  }

  @override
  Future<void> close() {
    _linkSubscription?.cancel();
    return super.close();
  }
}
