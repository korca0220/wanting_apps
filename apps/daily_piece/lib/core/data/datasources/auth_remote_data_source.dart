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
    return _client.auth.onAuthStateChange.asyncMap((event) async {
      final session = event.session;
      if (session != null) {
        await upsertCurrentUserProfile();
      }
      return session;
    });
  }

  Session? get currentSession => _client.auth.currentSession;

  User? get currentUser => _client.auth.currentUser;

  Future<void> upsertCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    final meta = user.userMetadata;
    final email = user.email ?? '';
    final localPart = email.contains('@') ? email.split('@').first : null;
    final displayName = _metadataString(meta?['name']) ?? localPart;
    final avatarUrl =
        _metadataString(meta?['avatar_url']) ?? _metadataString(meta?['picture']);

    await _client.from('profiles').upsert({
      'user_id': user.id,
      'display_name': displayName,
      'avatar_url': avatarUrl,
    }, onConflict: 'user_id');
  }

  Future<Map<String, dynamic>?> fetchCurrentUserProfileRow() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    return _client
        .from('profiles')
        .select('display_name, avatar_url')
        .eq('user_id', user.id)
        .maybeSingle();
  }

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

String? _metadataString(dynamic value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  return null;
}
