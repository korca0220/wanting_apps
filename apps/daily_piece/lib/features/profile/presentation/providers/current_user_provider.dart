import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/datasources/auth_remote_data_source.dart';

part 'current_user_provider.g.dart';

/// Lightweight projection of the signed-in user for the Profile screen.
/// Pulled directly from the Supabase auth source — there's no domain User
/// entity yet, and the renewal scope intentionally avoids inventing one.
@immutable
class CurrentUser {
  const CurrentUser({this.name, required this.email, required this.joinedAt});

  final String? name;
  final String email;
  final DateTime joinedAt;
}

@Riverpod(keepAlive: false)
CurrentUser? currentUser(Ref ref) {
  final user = ref.watch(authRemoteDataSourceProvider).currentUser;
  if (user == null) return null;

  final created = user.createdAt;
  final joinedAt = DateTime.tryParse(created) ?? DateTime.now();

  return CurrentUser(
    name: user.userMetadata?['name'] as String?,
    email: user.email ?? '',
    joinedAt: joinedAt,
  );
}
