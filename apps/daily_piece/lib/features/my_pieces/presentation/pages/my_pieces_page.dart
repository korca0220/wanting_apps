import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../new_piece/presentation/widgets/new_piece_sheet.dart';
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

  bool _isSameLocalDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final feed = ref.watch(myPiecesFeedProvider);
    final now = DateTime.now();
    final monthLabel = '${_monthsLong[now.month - 1]} ${now.year}';
    final showCreateButton = feed.maybeWhen(
      data: (state) {
        return !state.items.any((piece) => _isSameLocalDate(piece.date, now));
      },
      orElse: () => false,
    );

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
      floatingActionButton: showCreateButton
          ? FloatingActionButton(
              onPressed: () => showNewPieceSheet(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
