import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/my_pieces_feed_provider.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';
import '../widgets/timeline_grid.dart';

/// Authenticated landing — paged feed of the user's Pieces. Empty state nudges
/// the user to create their first Piece.
class MyPiecesPage extends ConsumerStatefulWidget {
  const MyPiecesPage({super.key});

  @override
  ConsumerState<MyPiecesPage> createState() => _MyPiecesPageState();
}

class _MyPiecesPageState extends ConsumerState<MyPiecesPage> {
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
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 400) {
      ref.read(myPiecesFeedProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final feed = ref.watch(myPiecesFeedProvider);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('DailyPiece')),
      body: SafeArea(
        child: feed.when(
          loading: () => const Center(child: WdsSpinner()),
          error: (e, _) => ErrorView(
            error: e,
            onRetry: () => ref.invalidate(myPiecesFeedProvider),
          ),
          data: (state) => state.items.isEmpty
              ? const EmptyView()
              : TimelineGrid(state: state, controller: _scroll),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new-piece'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
