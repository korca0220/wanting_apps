import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';

part 'today_piece_provider.g.dart';

/// Today's Piece for the signed-in user, or `null` while none is saved yet.
/// Invalidate after a successful save to flip the page from compose → view.
@riverpod
Future<Piece?> todayPiece(Ref ref) {
  return ref.watch(pieceRepositoryProvider).getToday();
}
