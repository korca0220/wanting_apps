import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/entities/entry.dart';

class TodayFilled extends StatelessWidget {
  const TodayFilled({super.key, required this.entry, required this.onTap});

  final Entry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;

    return SingleChildScrollView(
      padding: EdgeInsets.all(spacing.componentLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: spacing.componentLg),
          GestureDetector(
            onTap: onTap,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: colors.primaryNormal,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: WdsSpacing.s16),
                  Expanded(
                    child: Text(
                      entry.text,
                      style: context.wdsType.title3.copyWith(
                        color: colors.labelNormal,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: spacing.componentMd),
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 14, color: colors.labelAssistive),
                const SizedBox(width: WdsSpacing.s4),
                const WdsText(
                  'Tap to edit',
                  style: WdsTextStyle.caption1,
                  color: WdsTextColor.assistive,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
