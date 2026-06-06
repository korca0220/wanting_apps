import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({
    super.key,
    required this.day,
    required this.isToday,
    required this.hasEntry,
    required this.colors,
  });

  final int day;
  final bool isToday;
  final bool hasEntry;
  final WdsColorScheme colors;

  @override
  Widget build(BuildContext context) {
    final type = context.wdsType;

    Color bg;
    Color textColor;

    if (isToday) {
      bg = colors.primaryNormal;
      textColor = colors.onPrimary;
    } else if (hasEntry) {
      bg = colors.primaryNormal.withValues(alpha: 0.12);
      textColor = colors.primaryNormal;
    } else {
      bg = Colors.transparent;
      textColor = colors.labelNormal;
    }

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '$day',
          style: type.body2.copyWith(
            color: textColor,
            fontWeight:
                (isToday || hasEntry) ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
