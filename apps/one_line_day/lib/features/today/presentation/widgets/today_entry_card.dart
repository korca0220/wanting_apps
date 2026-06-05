import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/entities/entry.dart';

class TodayEntryCard extends StatelessWidget {
  const TodayEntryCard({super.key, required this.entry, required this.onTap});

  final Entry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;

    return GestureDetector(
      onTap: onTap,
      child: WdsCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WdsText(entry.text, style: WdsTextStyle.body1),
              SizedBox(height: spacing.componentSm),
              WdsText(
                'Tap to edit',
                style: WdsTextStyle.caption1,
                color: WdsTextColor.alternative,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
