import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';

part 'all_pieces_provider.g.dart';

/// All Pieces for the signed-in user, used as the base set for client-side
/// search and month-chip derivation. Capped at a large limit — once a user
/// gets close to it, this needs to flip to server-side search.
@Riverpod(keepAlive: false)
Future<List<Piece>> allPieces(Ref ref) {
  return ref.read(pieceRepositoryProvider).list(limit: 1000);
}
