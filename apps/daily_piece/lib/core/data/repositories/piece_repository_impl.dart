import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/piece.dart';
import '../../domain/exceptions/piece_exceptions.dart';
import '../../domain/repositories/piece_repository.dart';
import '../datasources/piece_remote_data_source.dart';

part 'piece_repository_impl.g.dart';

@Riverpod(keepAlive: true)
PieceRepository pieceRepository(Ref ref) =>
    PieceRepositoryImpl(ref.watch(pieceRemoteDataSourceProvider));

/// Maps Supabase rows → [Piece] and translates Postgres unique-violation
/// (23505) into the domain-level [PieceAlreadyExistsToday].
class PieceRepositoryImpl implements PieceRepository {
  PieceRepositoryImpl(this._remote);

  final PieceRemoteDataSource _remote;

  @override
  Future<Piece?> getToday() async {
    final userId = _remote.currentUserId;
    if (userId == null) return null;
    final row = await _remote.fetchTodayRow(
      userId: userId,
      date: _localDateString(DateTime.now()),
    );
    if (row == null) return null;
    return _mapRow(row);
  }

  @override
  Future<Piece> create({
    required Uint8List photoBytes,
    required String comment,
  }) async {
    final userId = _remote.currentUserId;
    if (userId == null) {
      throw const AuthException('Not signed in.');
    }
    final pieceId = const Uuid().v4();
    final path = '$userId/$pieceId.jpg';
    await _remote.uploadPhoto(path, photoBytes);
    try {
      final row = await _remote.insertRow(
        id: pieceId,
        userId: userId,
        photoPath: path,
        comment: comment,
        date: _localDateString(DateTime.now()),
      );
      return _mapRow(row);
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        await _remote.deletePhoto(path);
        throw const PieceAlreadyExistsToday();
      }
      rethrow;
    }
  }

  @override
  Future<String> signedPhotoUrl(String path, {int expiresInSeconds = 3600}) {
    return _remote.createSignedUrl(path, expiresInSeconds);
  }

  @override
  Future<Piece?> getById(String id) async {
    final row = await _remote.fetchRowById(id);
    if (row == null) return null;
    return _mapRow(row);
  }

  @override
  Future<List<Piece>> list({required int limit, DateTime? before}) async {
    final userId = _remote.currentUserId;
    if (userId == null) return const [];
    final rows = await _remote.listRows(
      userId: userId,
      limit: limit,
      beforeDate: before == null ? null : _localDateString(before),
    );
    return rows.map(_mapRow).toList(growable: false);
  }
}

Piece _mapRow(Map<String, dynamic> row) {
  return Piece(
    id: row['id'] as String,
    photoPath: row['photo_path'] as String,
    comment: row['comment'] as String,
    date: DateTime.parse(row['date'] as String),
  );
}

String _localDateString(DateTime now) {
  final y = now.year.toString().padLeft(4, '0');
  final m = now.month.toString().padLeft(2, '0');
  final d = now.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
