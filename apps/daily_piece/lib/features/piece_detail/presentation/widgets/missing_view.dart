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
            const WdsText('Piece를 찾을 수 없어요.', style: WdsTextStyle.headline2),
            SizedBox(height: spacing.componentSm),
            const WdsText(
              '이미 삭제됐거나 접근 권한이 없어요.',
              style: WdsTextStyle.body2,
              color: WdsTextColor.alternative,
            ),
            SizedBox(height: spacing.componentXl),
            WdsButton(
              onPressed: () => context.go('/collection'),
              child: const Text('컬렉션으로'),
            ),
          ],
        ),
      ),
    );
  }
}
