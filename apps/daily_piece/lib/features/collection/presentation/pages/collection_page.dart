import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/collection_feed_provider.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/timeline_grid.dart';

/// Timeline grid of the user's Pieces. Three columns, keyset-paginated by
/// scroll. Empty state nudges the user back to /today to create their first
/// Piece.
class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key});

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();

    _scroll.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scroll
      ..removeListener(_onScroll)
      ..dispose();

    super.dispose();
  }

  void _onScroll() {
    // Trigger near the bottom so the next page lands before the user hits it.
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 400) {
      ref.read(collectionFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final feed = ref.watch(collectionFeedProvider);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('Collection')),
      body: SafeArea(
        child: feed.when(
          loading: () => const Center(child: WdsSpinner()),
          error: (e, _) => ErrorView(
            error: e,
            onRetry: () => ref.invalidate(collectionFeedProvider),
          ),
          data: (state) => state.items.isEmpty
              ? const EmptyView()
              : TimelineGrid(state: state, controller: _scroll),
        ),
      ),
    );
  }
}
