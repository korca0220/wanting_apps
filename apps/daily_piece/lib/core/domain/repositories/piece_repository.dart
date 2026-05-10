import 'dart:typed_data';

import '../entities/piece.dart';

/// Domain-layer port for Piece persistence. Concrete implementation lives in
/// `core/data/repositories/`. Presentation depends on this interface so the
/// data source can be swapped (e.g., fake for tests, local cache later).
abstract class PieceRepository {
  /// Today's Piece for the signed-in user, or `null` if none yet.
  /// "Today" is the device's local calendar day.
  Future<Piece?> getToday();

  /// Uploads bytes to Storage then inserts the row. Throws
  /// [PieceAlreadyExistsToday] if today's Piece already exists.
  Future<Piece> create({
    required Uint8List photoBytes,
    required String comment,
  });

  /// Short-lived signed URL for displaying a private Piece photo.
  Future<String> signedPhotoUrl(String path, {int expiresInSeconds = 3600});

  /// Page of the signed-in user's Pieces, ordered `date desc`. `before` is an
  /// exclusive cursor — pass the last item's `date` to fetch the next page.
  /// Empty list when nothing left or signed out.
  Future<List<Piece>> list({required int limit, DateTime? before});

  /// One Piece by primary key, or `null` if the row doesn't exist or RLS
  /// hides it (e.g. signed out, or the id belongs to another user).
  Future<Piece?> getById(String id);
}
