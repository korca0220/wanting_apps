import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

const _monthsLong = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class MonthChips extends StatelessWidget {
  const MonthChips({
    super.key,
    required this.months,
    required this.selectedYear,
    required this.selectedMonth,
    required this.onSelect,
  });

  final List<({int year, int month})> months;
  final int? selectedYear;
  final int? selectedMonth;
  final void Function({int? year, int? month}) onSelect;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final entries = <({String label, int? year, int? month})>[
      (label: 'All', year: null, month: null),
      ...months.map(
        (m) => (label: _monthsLong[m.month - 1], year: m.year, month: m.month),
      ),
    ];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: spacing.componentXl),
      itemCount: entries.length,
      separatorBuilder: (_, _) => SizedBox(width: spacing.componentSm),
      itemBuilder: (_, i) {
        final e = entries[i];
        final active = e.year == selectedYear && e.month == selectedMonth;
        return SearchMonthChip(
          label: e.label,
          active: active,
          onTap: () => onSelect(year: e.year, month: e.month),
        );
      },
    );
  }
}

class SearchMonthChip extends StatelessWidget {
  const SearchMonthChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? colors.primaryNormal : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? colors.primaryNormal : colors.lineNormalNeutral,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: active ? colors.staticWhite : colors.labelNormal,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
