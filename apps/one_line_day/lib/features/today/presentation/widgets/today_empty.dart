import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class TodayEmpty extends StatelessWidget {
  const TodayEmpty({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.backgroundNormalAlternative,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: colors.labelAlternative,
                  size: 22,
                ),
              ),
              const SizedBox(height: WdsSpacing.s16),
              const WdsText(
                'How was today?',
                style: WdsTextStyle.headline1,
                color: WdsTextColor.neutral,
              ),
              const SizedBox(height: WdsSpacing.s8),
              const WdsText(
                'Tap to write one line',
                style: WdsTextStyle.body2,
                color: WdsTextColor.disable,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
