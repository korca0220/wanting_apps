import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import 'calendar_day_cell.dart';

class MonthGrid extends StatelessWidget {
  const MonthGrid({
    super.key,
    required this.visibleMonth,
    required this.selectedDate,
    required this.piecesByDate,
    required this.onCellTap,
  });

  final DateTime visibleMonth;
  final DateTime? selectedDate;
  final Map<String, dynamic> piecesByDate;
  final void Function(DateTime, bool, dynamic) onCellTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final today = DateTime.now();
    final firstOfMonth = DateTime(visibleMonth.year, visibleMonth.month, 1);
    final leadingBlank = firstOfMonth.weekday % 7;
    final gridStart = firstOfMonth.subtract(Duration(days: leadingBlank));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: spacing.componentSm,
        crossAxisSpacing: spacing.componentSm,
      ),
      itemCount: 42,
      itemBuilder: (_, i) {
        final date = gridStart.add(Duration(days: i));
        final inMonth = date.month == visibleMonth.month;
        final isToday =
            date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
        final isSelected =
            selectedDate != null &&
            date.year == selectedDate!.year &&
            date.month == selectedDate!.month &&
            date.day == selectedDate!.day;
        final key = _key(date);
        final piece = piecesByDate[key];

        return CalendarDayCell(
          day: date.day,
          inCurrentMonth: inMonth,
          isToday: isToday,
          isSelected: isSelected,
          hasPiece: piece != null,
          onTap: () => onCellTap(date, inMonth, piece),
        );
      },
    );
  }
}

String _key(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
