import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';

part 'collection_feed_provider.g.dart';

/// Snapshot of the timeline feed — items so far, whether more pages remain,
/// and whether a `loadMore` is currently in flight (so the UI can show a
/// footer spinner without flipping the whole grid into loading state).
@immutable
class CollectionFeedState {
  const CollectionFeedState({
    required this.items,
    required this.hasMore,
    required this.loadingMore,
  });

  final List<Piece> items;
  final bool hasMore;
  final bool loadingMore;

  CollectionFeedState copyWith({
    List<Piece>? items,
    bool? hasMore,
    bool? loadingMore,
  }) {
    return CollectionFeedState(
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      loadingMore: loadingMore ?? this.loadingMore,
    );
  }
}

/// Paged feed of the user's Pieces, ordered `date desc`. `loadMore` keyset-
/// paginates on the last item's date. Initial load returns to AsyncLoading
/// (full-grid spinner); subsequent pages flip `loadingMore` only.
@Riverpod(keepAlive: false)
class CollectionFeed extends _$CollectionFeed {
  static const int _pageSize = 30;

  @override
  Future<CollectionFeedState> build() async {
    final items = await ref
        .read(pieceRepositoryProvider)
        .list(limit: _pageSize);

    return CollectionFeedState(
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
        CollectionFeedState(
          items: [...current.items, ...more],
          hasMore: more.length == _pageSize,
          loadingMore: false,
        ),
      );
    } catch (_) {
      // Keep loaded items visible. Surfacing the error inline (snackbar / retry
      // tile) is a follow-up; for now the footer just reverts and another
      // scroll attempt re-runs the request.
      state = AsyncData(current.copyWith(loadingMore: false));
    }
  }
}
