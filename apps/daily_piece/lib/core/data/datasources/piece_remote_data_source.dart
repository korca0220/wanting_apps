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

  Future<Map<String, dynamic>?> fetchRowById(String id) {
    return _client.from('pieces').select().eq('id', id).maybeSingle();
  }

  /// Keyset page on `(date desc)`. `beforeDate`, when supplied, is exclusive.
  Future<List<Map<String, dynamic>>> listRows({
    required String userId,
    required int limit,
    String? beforeDate,
  }) async {
    var query = _client.from('pieces').select().eq('user_id', userId);
    if (beforeDate != null) {
      query = query.lt('date', beforeDate);
    }

    final rows = await query.order('date', ascending: false).limit(limit);

    return List<Map<String, dynamic>>.from(rows);
  }

  /// Free-text search on `comment` (case-insensitive substring) with an
  /// optional date range. Either filter can be null. Server-side filtering
  /// keeps the wire payload small as the user's piece count grows.
  Future<List<Map<String, dynamic>>> searchRows({
    required String userId,
    String? query,
    String? fromDate,
    String? toDate,
    required int limit,
  }) async {
    var q = _client.from('pieces').select().eq('user_id', userId);
    if (query != null && query.isNotEmpty) {
      // Escape ilike wildcards in the user's input so they're treated as
      // literals; the wrapping %...% is added unescaped to bracket the
      // substring match.
      final escaped = query.replaceAll('%', r'\%').replaceAll('_', r'\_');
      q = q.ilike('comment', '%$escaped%');
    }
    if (fromDate != null) q = q.gte('date', fromDate);
    if (toDate != null) q = q.lte('date', toDate);

    final rows = await q.order('date', ascending: false).limit(limit);

    return List<Map<String, dynamic>>.from(rows);
  }

  /// Lean dates-only query for deriving month chips. Returns one map per
  /// piece with a single `date` column — comments and photo paths stay on
  /// the server.
  Future<List<Map<String, dynamic>>> listAllDateRows({
    required String userId,
  }) async {
    final rows = await _client
        .from('pieces')
        .select('date')
        .eq('user_id', userId)
        .order('date', ascending: false);

    return List<Map<String, dynamic>>.from(rows);
  }

  Future<List<Map<String, dynamic>>> listMonthRows({
    required String userId,
    required String fromDate,
    required String toDate,
  }) async {
    final rows = await _client
        .from('pieces')
        .select()
        .eq('user_id', userId)
        .gte('date', fromDate)
        .lte('date', toDate)
        .order('date', ascending: true);

    return List<Map<String, dynamic>>.from(rows);
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

  Future<Map<String, dynamic>> updateRow({
    required String id,
    required String comment,
  }) {
    return _client
        .from('pieces')
        .update({'comment': comment})
        .eq('id', id)
        .select()
        .single();
  }

  Future<Map<String, dynamic>> updatePhotoPathRow({
    required String id,
    required String photoPath,
  }) {
    return _client
        .from('pieces')
        .update({'photo_path': photoPath})
        .eq('id', id)
        .select()
        .single();
  }

  Future<void> deleteRow(String id) async {
    await _client.from('pieces').delete().eq('id', id);
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
