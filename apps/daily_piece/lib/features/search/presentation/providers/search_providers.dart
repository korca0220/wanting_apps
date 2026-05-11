import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';

part 'search_providers.g.dart';

/// Distinct months the user has Pieces in, newest-first. Used to render
/// the Search month-chip row. Survives query changes — only invalidates
/// when the piece set itself changes.
@Riverpod(keepAlive: false)
Future<List<({int year, int month})>> pieceMonths(Ref ref) {
  return ref.read(pieceRepositoryProvider).listPieceMonths();
}

@immutable
class SearchFilter {
  const SearchFilter({this.query = '', this.year, this.month});

  final String query;
  final int? year;
  final int? month;

  bool get isAllMonths => year == null;

  @override
  bool operator ==(Object other) =>
      other is SearchFilter &&
      other.query == query &&
      other.year == year &&
      other.month == month;

  @override
  int get hashCode => Object.hash(query, year, month);
}

/// Server-driven search results for the current [SearchFilter]. The family
/// key debounces naturally — Riverpod dedupes identical filter instances
/// (operator== on SearchFilter), so repeated keystrokes for the same
/// trimmed query share one in-flight request.
@Riverpod(keepAlive: false)
Future<List<Piece>> searchResults(Ref ref, {required SearchFilter filter}) {
  return ref
      .read(pieceRepositoryProvider)
      .search(
        query: filter.query.isEmpty ? null : filter.query,
        year: filter.year,
        month: filter.month,
      );
}
