import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../providers/my_pieces_feed_provider.dart';
import 'piece_card.dart';

/// Vertical full-width card feed plus a `loadingMore` footer when the feed
/// notifier is fetching the next page.
class CardFeed extends StatelessWidget {
  const CardFeed({super.key, required this.state, required this.controller});

  final MyPiecesFeedState state;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final padding = EdgeInsets.symmetric(
      horizontal: spacing.componentXl,
      vertical: spacing.componentMd,
    );
    final gap = spacing.componentLg;

    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverPadding(
          padding: padding,
          sliver: SliverList.separated(
            itemCount: state.items.length,
            separatorBuilder: (_, _) => SizedBox(height: gap),
            itemBuilder: (context, i) {
              final piece = state.items[i];
              return PieceCard(
                piece: piece,
                onTap: () => context.go('/my-pieces/${piece.id}'),
              );
            },
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
