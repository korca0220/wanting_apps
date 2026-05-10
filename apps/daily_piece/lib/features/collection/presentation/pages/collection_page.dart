import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/collection_feed_provider.dart';
import '../widgets/piece_thumbnail.dart';

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
          error: (e, _) => _ErrorView(
            error: e,
            onRetry: () => ref.invalidate(collectionFeedProvider),
          ),
          data: (state) => state.items.isEmpty
              ? const _EmptyView()
              : _Grid(state: state, controller: _scroll),
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({required this.state, required this.controller});

  final CollectionFeedState state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final padding = EdgeInsets.all(spacing.componentMd);
    final gap = spacing.componentSm;
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: gap,
              crossAxisSpacing: gap,
            ),
            delegate: SliverChildBuilderDelegate((context, i) {
              final piece = state.items[i];
              return PieceThumbnail(
                piece: piece,
                onTap: () => context.go('/collection/${piece.id}'),
              );
            }, childCount: state.items.length),
          ),
        ),
        if (state.loadingMore)
          SliverPadding(
            padding: EdgeInsets.symmetric(vertical: spacing.componentLg),
            sliver: const SliverToBoxAdapter(
              child: Center(child: WdsSpinner()),
            ),
          ),
      ],
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.componentXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WdsText('아직 Piece가 없어요.', style: WdsTextStyle.headline2),
            SizedBox(height: spacing.componentSm),
            const WdsText(
              '오늘에서 첫 Piece를 만들어보세요.',
              style: WdsTextStyle.body2,
              color: WdsTextColor.alternative,
            ),
            SizedBox(height: spacing.componentXl),
            WdsButton(
              onPressed: () => context.go('/today'),
              child: const Text('오늘로 가기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.componentXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WdsText('타임라인을 불러오지 못했어요.', style: WdsTextStyle.headline2),
            SizedBox(height: spacing.componentSm),
            WdsText(
              '$error',
              style: WdsTextStyle.body2,
              color: WdsTextColor.alternative,
            ),
            SizedBox(height: spacing.componentXl),
            WdsButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
