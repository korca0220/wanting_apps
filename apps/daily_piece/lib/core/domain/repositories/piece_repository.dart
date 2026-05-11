import 'dart:typed_data';

import '../entities/piece.dart';

/// Domain-layer port for Piece persistence. Concrete implementation lives in
/// `core/data/repositories/`. Presentation depends on this interface so the
/// data source can be swapped (e.g., fake for tests, local cache later).
abstract class PieceRepository {
  /// Today's Piece for the signed-in user, or `null` if none yet.
  /// "Today" is the device's local calendar day.
  Future<Piece?> getToday();

  /// Uploads bytes to Storage then inserts the row. Defaults to today's
  /// local date; pass [date] to fill in a different day (e.g. an empty
  /// past day picked from the calendar). Throws [PieceAlreadyExistsToday]
  /// if a Piece for that user/date already exists.
  Future<Piece> create({
    required Uint8List photoBytes,
    required String comment,
    DateTime? date,
  });

  /// All Pieces for the signed-in user within the given calendar month.
  /// Used by the Calendar screen to render the dot map.
  Future<List<Piece>> listByMonth({required int year, required int month});

  /// Server-side caption search with optional month constraint. Either
  /// filter can be null/omitted. Returns `date desc`, capped at [limit].
  Future<List<Piece>> search({
    String? query,
    int? year,
    int? month,
    int limit = 100,
  });

  /// Distinct (year, month) pairs the signed-in user has Pieces in,
  /// ordered newest-first. Used by Search to derive the month chip row
  /// without paging the full feed client-side.
  Future<List<({int year, int month})>> listPieceMonths();

  /// Short-lived signed URL for displaying a private Piece photo.
  Future<String> signedPhotoUrl(String path, {int expiresInSeconds = 3600});

  /// Page of the signed-in user's Pieces, ordered `date desc`. `before` is an
  /// exclusive cursor — pass the last item's `date` to fetch the next page.
  /// Empty list when nothing left or signed out.
  Future<List<Piece>> list({required int limit, DateTime? before});

  /// One Piece by primary key, or `null` if the row doesn't exist or RLS
  /// hides it (e.g. signed out, or the id belongs to another user).
  Future<Piece?> getById(String id);

  /// Updates the comment of an existing Piece. Date stays immutable —
  /// changing it would collide with UNIQUE(user_id, date).
  Future<Piece> updateComment({required String id, required String comment});

  /// Swaps the photo bound to a Piece. Uploads bytes to a fresh path,
  /// updates the row's `photo_path`, then best-effort removes the old
  /// Storage object. Returns the updated Piece (with the new path).
  Future<Piece> replacePhoto({
    required String id,
    required String oldPhotoPath,
    required Uint8List newPhotoBytes,
  });

  /// Deletes a Piece — row first, then a best-effort Storage object cleanup.
  /// `photoPath` is required because Storage delete is decoupled from the
  /// row delete (no FK there) and the path isn't recoverable post-row-delete.
  Future<void> delete({required String id, required String photoPath});
}
