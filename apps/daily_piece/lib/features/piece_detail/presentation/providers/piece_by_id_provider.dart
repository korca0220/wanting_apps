import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';

part 'piece_by_id_provider.g.dart';

/// One Piece by id. `null` means the row is gone or hidden by RLS — the page
/// renders that as a "찾을 수 없어요" empty state rather than a hard error.
@riverpod
Future<Piece?> pieceById(Ref ref, String id) {
  return ref.watch(pieceRepositoryProvider).getById(id);
}
