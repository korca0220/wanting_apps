import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// One cell in the month grid. Five-state matrix from the spec — current
/// month / other month / today / has-piece / selected can stack.
class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.day,
    required this.inCurrentMonth,
    required this.isToday,
    required this.isSelected,
    required this.hasPiece,
    required this.onTap,
  });

  final int day;
  final bool inCurrentMonth;
  final bool isToday;
  final bool isSelected;
  final bool hasPiece;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final textColor = !inCurrentMonth
        ? colors.labelDisable
        : (isToday ? colors.primaryNormal : colors.labelNormal);
    final borderColor = isSelected || isToday ? colors.primaryNormal : null;
    final fillColor = isSelected ? colors.primarySubtle : null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AspectRatio(
        aspectRatio: 1,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: fillColor,
            shape: BoxShape.circle,
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1)
                : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '$day',
                style: TextStyle(
                  color: textColor,
                  fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (hasPiece && inCurrentMonth)
                Positioned(
                  bottom: 6,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.primaryNormal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
