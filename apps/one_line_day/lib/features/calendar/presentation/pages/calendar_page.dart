import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../../core/providers/all_entries_provider.dart';
import '../../../../core/utils/date_key.dart';
import '../../../edit_entry/presentation/widgets/edit_entry_sheet.dart';
import '../providers/calendar_providers.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  late DateTime _focusedMonth;

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
  }

  void _prevMonth() => setState(
      () => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1));

  void _nextMonth() => setState(
      () => _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1));

  bool get _isCurrentMonth {
    final now = DateTime.now();
    return _focusedMonth.year == now.year && _focusedMonth.month == now.month;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final datesWithEntries = ref.watch(datesWithEntriesProvider);
    final allEntries = ref.watch(allEntriesProvider).valueOrNull ?? [];
    final todayKey = dateKey(DateTime.now());

    final daysInMonth =
        DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startWeekday =
        DateTime(_focusedMonth.year, _focusedMonth.month, 1).weekday % 7;

    final monthEntryCount = datesWithEntries
        .where((d) => d.startsWith(
            '${_focusedMonth.year.toString().padLeft(4, '0')}-'
            '${_focusedMonth.month.toString().padLeft(2, '0')}'))
        .length;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.componentMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: spacing.componentMd),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    onPressed: _prevMonth,
                    color: colors.labelNormal,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        WdsText(
                          _monthNames[_focusedMonth.month - 1],
                          style: WdsTextStyle.heading1,
                          color: WdsTextColor.strong,
                        ),
                        WdsText(
                          _focusedMonth.year.toString(),
                          style: WdsTextStyle.caption1,
                          color: WdsTextColor.alternative,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    onPressed: _nextMonth,
                    color: colors.labelNormal,
                  ),
                ],
              ),
              if (monthEntryCount > 0) ...[
                const SizedBox(height: WdsSpacing.s4),
                Center(
                  child: WdsText(
                    '$monthEntryCount line${monthEntryCount == 1 ? '' : 's'} this month',
                    style: WdsTextStyle.caption1,
                    color: WdsTextColor.alternative,
                  ),
                ),
              ],
              SizedBox(height: spacing.componentMd),
              Row(
                children: _dayLabels
                    .map((d) => Expanded(
                          child: Center(
                            child: WdsText(
                              d,
                              style: WdsTextStyle.caption2,
                              color: WdsTextColor.assistive,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: WdsSpacing.s8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  childAspectRatio: 1,
                ),
                itemCount: startWeekday + daysInMonth,
                itemBuilder: (context, index) {
                  if (index < startWeekday) return const SizedBox.shrink();

                  final day = index - startWeekday + 1;
                  final date = DateTime(
                      _focusedMonth.year, _focusedMonth.month, day);
                  final key = dateKey(date);
                  final hasEntry = datesWithEntries.contains(key);
                  final isToday = key == todayKey;

                  Entry? entry;
                  if (hasEntry) {
                    for (final e in allEntries) {
                      if (e.date == key) {
                        entry = e;
                        break;
                      }
                    }
                  }

                  return GestureDetector(
                    onTap: () => showEditEntrySheet(
                      context,
                      date: key,
                      existing: entry,
                    ),
                    child: Center(
                      child: _CalendarCell(
                        day: day,
                        isToday: isToday,
                        hasEntry: hasEntry,
                        colors: colors,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
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
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '$day',
          style: type.body2.copyWith(
            color: textColor,
            fontWeight: (isToday || hasEntry) ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
