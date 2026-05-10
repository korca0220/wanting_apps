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
}
