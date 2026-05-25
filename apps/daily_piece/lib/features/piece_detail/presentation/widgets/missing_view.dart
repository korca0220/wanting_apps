import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MissingView extends StatelessWidget {
  const MissingView({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.componentXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WdsText('Piece not found', style: WdsTextStyle.headline2),
            SizedBox(height: spacing.componentSm),
            const WdsText(
              "It may have been deleted, or you don't have access.",
              style: WdsTextStyle.body2,
              color: WdsTextColor.alternative,
            ),
            SizedBox(height: spacing.componentXl),
            WdsButton(
              onPressed: () => context.go('/my-pieces'),
              child: const Text('Go to My Pieces'),
            ),
          ],
        ),
      ),
    );
  }
}
