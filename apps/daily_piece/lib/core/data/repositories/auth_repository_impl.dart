import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../../domain/exceptions/auth_exceptions.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

part 'auth_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) =>
    AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider));

/// Translates Supabase's [AuthException] → domain [AuthFailure] and projects
/// the auth state stream from `Session?` to a presentation-friendly `bool`.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Stream<bool> watchSignedIn() {
    return _remote.sessionStream().map((session) => session != null);
  }

  @override
  bool get isSignedIn => _remote.currentSession != null;

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _remote.signInWithPassword(email: email, password: password);
      await _remote.upsertCurrentUserProfile();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _remote.signInWithGoogle();
      // When OAuth callback has already completed, this syncs immediately.
      // If not yet completed, it's a no-op and Profile sync happens when
      // currentUserProvider reads auth state next.
      await _remote.upsertCurrentUserProfile();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    String? name,
  }) async {
    try {
      final trimmed = name?.trim();
      final res = await _remote.signUp(
        email: email,
        password: password,
        data: (trimmed != null && trimmed.isNotEmpty)
            ? {'name': trimmed}
            : null,
      );

      if (res.session != null) {
        await _remote.upsertCurrentUserProfile();
      }

      return res.session != null;
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<void> signOut() => _remote.signOut();

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _remote.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }
}
