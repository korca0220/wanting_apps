import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../core/domain/piece.dart';

part 'piece_repository.g.dart';

@Riverpod(keepAlive: true)
PieceRepository pieceRepository(Ref ref) =>
    PieceRepository(Supabase.instance.client);

/// Thin wrapper around Supabase for the Today flow. Storage upload + Postgres
/// insert are coupled here because the row stores the path produced by the
/// upload — keeping them adjacent makes the failure modes easier to reason
/// about.
class PieceRepository {
  PieceRepository(this._client);

  final SupabaseClient _client;

  /// Returns today's Piece for the signed-in user, or `null` if none yet.
  /// "Today" is the device's local calendar day — same convention used by
  /// the UNIQUE(user_id, date) constraint.
  Future<Piece?> getToday() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    final row = await _client
        .from('pieces')
        .select()
        .eq('user_id', user.id)
        .eq('date', _localDateString(DateTime.now()))
        .maybeSingle();
    if (row == null) return null;
    return Piece.fromJson(row);
  }

  /// Uploads bytes to Storage then inserts the row. Surfaces
  /// [PieceAlreadyExistsToday] if today's row already exists, [AuthException]
  /// if the user signed out mid-flight.
  Future<Piece> create({
    required Uint8List photoBytes,
    required String comment,
  }) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw const AuthException('Not signed in.');
    }
    final pieceId = const Uuid().v4();
    final path = '${user.id}/$pieceId.jpg';
    await _client.storage
        .from('pieces')
        .uploadBinary(
          path,
          photoBytes,
          fileOptions: const FileOptions(contentType: 'image/jpeg'),
        );
    try {
      final row = await _client
          .from('pieces')
          .insert({
            'id': pieceId,
            'user_id': user.id,
            'photo_path': path,
            'comment': comment,
            'date': _localDateString(DateTime.now()),
          })
          .select()
          .single();
      return Piece.fromJson(row);
    } on PostgrestException catch (e) {
      // 23505 = unique_violation. Best-effort cleanup of the orphaned object.
      if (e.code == '23505') {
        await _client.storage.from('pieces').remove([path]).catchError(
          (_) => <FileObject>[],
        );
        throw const PieceAlreadyExistsToday();
      }
      rethrow;
    }
  }

  /// Short-lived signed URL for displaying a Piece's photo from the private
  /// `pieces` bucket. 1 hour is plenty for a single screen render.
  Future<String> signedPhotoUrl(String path, {int expiresInSeconds = 3600}) {
    return _client.storage.from('pieces').createSignedUrl(path, expiresInSeconds);
  }
}

/// Thrown when INSERT collides with the UNIQUE(user_id, date) constraint —
/// i.e. the user already saved a Piece for today.
class PieceAlreadyExistsToday implements Exception {
  const PieceAlreadyExistsToday();
  @override
  String toString() => 'PieceAlreadyExistsToday';
}

String _localDateString(DateTime now) {
  final y = now.year.toString().padLeft(4, '0');
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
