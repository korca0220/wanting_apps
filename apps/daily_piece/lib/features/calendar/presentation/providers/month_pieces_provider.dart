import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';

part 'month_pieces_provider.g.dart';

/// Pieces for a given calendar month, keyed by `yyyy-mm-dd` for O(1) cell
/// lookups. `(year, month)` is the family key so the cache survives month
/// scrubbing without re-fetching adjacent months on every step.
@Riverpod(keepAlive: false)
Future<Map<String, Piece>> monthPieces(
  Ref ref, {
  required int year,
  required int month,
}) async {
  final pieces = await ref
      .read(pieceRepositoryProvider)
      .listByMonth(year: year, month: month);

  return {for (final p in pieces) _key(p.date): p};
}

String _key(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
