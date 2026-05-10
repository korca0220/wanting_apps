import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/my_pieces_feed_provider.dart';
import '../widgets/card_feed.dart';
import '../widgets/empty_view.dart';
import '../widgets/error_view.dart';

const _monthsLong = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

/// Authenticated landing — paged full-width card feed of the user's Pieces.
/// FAB launches the New Piece flow. Empty state nudges the user to create
/// their first Piece.
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
    final now = DateTime.now();
    final monthLabel = '${_monthsLong[now.month - 1]} ${now.year}';

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        title: const Text('DailyPiece'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: WdsText(
                monthLabel,
                style: WdsTextStyle.caption1,
                color: WdsTextColor.alternative,
              ),
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.notifications_none_outlined),
            tooltip: '알림',
          ),
        ],
      ),
      body: SafeArea(
        child: feed.when(
          loading: () => const Center(child: WdsSpinner()),
          error: (e, _) => ErrorView(
            error: e,
            onRetry: () => ref.invalidate(myPiecesFeedProvider),
          ),
          data: (state) => state.items.isEmpty
              ? const EmptyView()
              : CardFeed(state: state, controller: _scroll),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new-piece'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
