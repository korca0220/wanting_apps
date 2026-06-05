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

  String get _monthLabel {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final colors = context.wdsColors;
    final datesWithEntries = ref.watch(datesWithEntriesProvider);
    final allEntries = ref.watch(allEntriesProvider).valueOrNull ?? [];

    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7; // 0=Sun

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.componentMd),
          child: Column(
            children: [
              SizedBox(height: spacing.componentMd),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: _prevMonth,
                  ),
                  Expanded(
                    child: Center(
                      child: WdsText(_monthLabel, style: WdsTextStyle.heading1),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
              SizedBox(height: spacing.componentSm),
              Row(
                children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                    .map((d) => Expanded(
                          child: Center(
                            child: WdsText(
                              d,
                              style: WdsTextStyle.caption1,
                              color: WdsTextColor.alternative,
                            ),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: spacing.componentXs),
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
                  final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
                  final key = dateKey(date);
                  final hasEntry = datesWithEntries.contains(key);
                  final isToday = key == dateKey(DateTime.now());

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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: isToday
                              ? BoxDecoration(
                                  color: colors.primaryNormal,
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: Center(
                            child: WdsText(
                              '$day',
                              style: WdsTextStyle.body2,
                              color: isToday
                                  ? WdsTextColor.onPrimary
                                  : WdsTextColor.normal,
                            ),
                          ),
                        ),
                        if (hasEntry)
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: colors.primaryNormal,
                              shape: BoxShape.circle,
                            ),
                          )
                        else
                          const SizedBox(height: 4),
                      ],
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
