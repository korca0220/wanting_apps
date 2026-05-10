import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'piece_remote_data_source.g.dart';

@Riverpod(keepAlive: true)
PieceRemoteDataSource pieceRemoteDataSource(Ref ref) =>
    PieceRemoteDataSource(Supabase.instance.client);

/// Thin pipe to Supabase for the `pieces` table + Storage bucket. Returns raw
/// rows / re-throws driver exceptions; the repository owns mapping and error
/// translation.
class PieceRemoteDataSource {
  PieceRemoteDataSource(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>?> fetchTodayRow({
    required String userId,
    required String date,
  }) {
    return _client
        .from('pieces')
        .select()
        .eq('user_id', userId)
        .eq('date', date)
        .maybeSingle();
  }

  Future<void> uploadPhoto(String path, Uint8List bytes) {
    return _client.storage
        .from('pieces')
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );
  }

  Future<Map<String, dynamic>> insertRow({
    required String id,
    required String userId,
    required String photoPath,
    required String comment,
    required String date,
  }) {
    return _client
        .from('pieces')
        .insert({
          'id': id,
          'user_id': userId,
          'photo_path': photoPath,
          'comment': comment,
          'date': date,
        })
        .select()
        .single();
  }

  /// Best-effort cleanup of an orphaned Storage object after a failed insert.
  Future<void> deletePhoto(String path) async {
    try {
      await _client.storage.from('pieces').remove([path]);
    } catch (_) {
      // intentional swallow — cleanup is best-effort.
    }
  }

  Future<String> createSignedUrl(String path, int expiresInSeconds) {
    return _client.storage
        .from('pieces')
        .createSignedUrl(path, expiresInSeconds);
  }

  String? get currentUserId => _client.auth.currentUser?.id;
}
