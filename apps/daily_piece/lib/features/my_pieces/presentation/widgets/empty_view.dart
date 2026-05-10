import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

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
              '오늘의 첫 Piece를 만들어보세요.',
              style: WdsTextStyle.body2,
              color: WdsTextColor.alternative,
            ),
            SizedBox(height: spacing.componentXl),
            WdsButton(
              onPressed: () => context.push('/new-piece'),
              child: const Text('첫 Piece 만들기'),
            ),
          ],
        ),
      ),
    );
  }
}
