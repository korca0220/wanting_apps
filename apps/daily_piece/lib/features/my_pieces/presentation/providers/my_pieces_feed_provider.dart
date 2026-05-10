import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';

part 'my_pieces_feed_provider.g.dart';

/// Snapshot of the My Pieces feed — items so far, whether more pages remain,
/// and whether a `loadMore` is currently in flight (so the UI can show a
/// footer spinner without flipping the whole list into loading state).
@immutable
class MyPiecesFeedState {
  const MyPiecesFeedState({
    required this.items,
    required this.hasMore,
    required this.loadingMore,
  });

  final List<Piece> items;
  final bool hasMore;
  final bool loadingMore;

  MyPiecesFeedState copyWith({
    List<Piece>? items,
    bool? hasMore,
    bool? loadingMore,
  }) {
    return MyPiecesFeedState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}

/// Paged feed of the user's Pieces, ordered `date desc`. `loadMore` keyset-
/// paginates on the last item's date. Initial load returns to AsyncLoading
/// (full-screen spinner); subsequent pages flip `loadingMore` only.
@Riverpod(keepAlive: false)
class MyPiecesFeed extends _$MyPiecesFeed {
  static const int _pageSize = 30;

  @override
  Future<MyPiecesFeedState> build() async {
    final items = await ref
        .read(pieceRepositoryProvider)
        .list(limit: _pageSize);

    return MyPiecesFeedState(
      items: items,
      hasMore: items.length == _pageSize,
      loadingMore: false,
    );
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null || !current.hasMore || current.loadingMore) return;

    state = AsyncData(current.copyWith(loadingMore: true));

    try {
      final more = await ref
          .read(pieceRepositoryProvider)
          .list(limit: _pageSize, before: current.items.last.date);

      state = AsyncData(
        MyPiecesFeedState(
          items: [...current.items, ...more],
          hasMore: more.length == _pageSize,
          loadingMore: false,
        ),
      );
    } catch (_) {
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}
