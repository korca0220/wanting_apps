import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/collection_feed_provider.dart';
import 'piece_thumbnail.dart';

/// Sliver-based 3-column grid that hosts the timeline feed plus a
/// `loadingMore` footer when the feed notifier is fetching the next page.
class TimelineGrid extends StatelessWidget {
  const TimelineGrid({
    super.key,
    required this.state,
    required this.controller,
  });

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
