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
  const CurrentUser({
    this.name,
    this.avatarUrl,
    required this.email,
    required this.joinedAt,
  });

  final String? name;
  final String? avatarUrl;
  final String email;
  final DateTime joinedAt;
}

@Riverpod(keepAlive: false)
Future<CurrentUser?> currentUser(Ref ref) async {
  final user = ref.watch(authRemoteDataSourceProvider).currentUser;
  if (user == null) return null;

  final created = user.createdAt;
  final joinedAt = DateTime.tryParse(created) ?? DateTime.now();
  final meta = user.userMetadata;
  final remote = ref.read(authRemoteDataSourceProvider);
  await remote.upsertCurrentUserProfile();
  final profile = await remote.fetchCurrentUserProfileRow();

  return CurrentUser(
    name:
        _metadataString(profile?['display_name']) ??
        _metadataString(meta?['name']),
    avatarUrl:
        _metadataString(profile?['avatar_url']) ??
        _metadataString(meta?['avatar_url']) ??
        _metadataString(meta?['picture']),
    email: user.email ?? '',
    joinedAt: joinedAt,
  );
}

String? _metadataString(dynamic value) {
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  return null;
}
