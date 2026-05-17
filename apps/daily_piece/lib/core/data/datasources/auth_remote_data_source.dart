import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_remote_data_source.g.dart';

const _oauthRedirectTo = 'wantingdailypiece://login-callback/';

@Riverpod(keepAlive: true)
AuthRemoteDataSource authRemoteDataSource(Ref ref) =>
    AuthRemoteDataSource(Supabase.instance.client);

/// Thin pipe to Supabase Auth. Returns native Supabase types / re-throws
/// driver exceptions; the repository handles error translation.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._client);

  final SupabaseClient _client;

  Stream<Session?> sessionStream() {
    return _client.auth.onAuthStateChange.map((event) => event.session);
  }

  Session? get currentSession => _client.auth.currentSession;

  User? get currentUser => _client.auth.currentUser;

  Future<AuthResponse> signInWithPassword({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<bool> signInWithGoogle() {
    return _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: _oauthRedirectTo,
      authScreenLaunchMode: LaunchMode.externalApplication,
    );
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) {
    return _client.auth.signUp(
      email: email,
      password: password,
      data: data,
    );
  }

  Future<void> signOut() => _client.auth.signOut();

  Future<void> resetPasswordForEmail(String email) {
    return _client.auth.resetPasswordForEmail(email);
  }
}
