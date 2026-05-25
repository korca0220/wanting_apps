import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, required this.onRetry});

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
            const WdsText(
              'Unable to load this piece',
              style: WdsTextStyle.headline2,
            ),
            SizedBox(height: spacing.componentSm),
            WdsText(
              '$error',
              style: WdsTextStyle.body2,
              color: WdsTextColor.alternative,
            ),
            SizedBox(height: spacing.componentXl),
            WdsButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
