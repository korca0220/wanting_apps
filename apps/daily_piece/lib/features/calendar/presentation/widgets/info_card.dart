import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class CalendarInfoCard extends StatelessWidget {
  const CalendarInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.lineNormalNeutral, width: 1),
      ),
      padding: EdgeInsets.all(spacing.componentLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colors.primarySubtle,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.calendar_today_outlined,
              size: 18,
              color: colors.primaryNormal,
            ),
          ),
          SizedBox(width: spacing.componentMd),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WdsText('Your Daily Journey', style: WdsTextStyle.heading1),
                SizedBox(height: 4),
                WdsText(
                  'Days with a blue dot have a piece. Tap any day to view or add a piece for that date.',
                  style: WdsTextStyle.body2,
                  color: WdsTextColor.alternative,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
