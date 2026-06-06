import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/all_entries_provider.dart';
import '../../../../core/utils/date_key.dart';
import '../../../edit_entry/presentation/widgets/edit_entry_sheet.dart';
import '../providers/today_providers.dart';
import '../widgets/today_empty.dart';
import '../widgets/today_filled.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  static const _weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  static const _months = [
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

  String _weekday(DateTime d) => _weekdays[d.weekday - 1];
  String _dateLabel(DateTime d) =>
      '${_months[d.month - 1]} ${d.day}, ${d.year}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final now = DateTime.now();
    final today = dateKey(now);
    final entriesAsync = ref.watch(allEntriesProvider);
    final entry = ref.watch(todayEntryProvider);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.componentLg,
                spacing.componentLg,
                spacing.componentLg,
                WdsSpacing.s20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WdsText(
                    _weekday(now),
                    style: WdsTextStyle.label1,
                    color: WdsTextColor.alternative,
                  ),
                  const SizedBox(height: WdsSpacing.s4),
                  WdsText(
                    _dateLabel(now),
                    style: WdsTextStyle.title2,
                    color: WdsTextColor.strong,
                  ),
                ],
              ),
            ),
            const WdsDivider(),
            Expanded(
              child: entriesAsync.when(
                loading: () => const Center(child: WdsSpinner()),
                error: (_, _) => const WdsFallbackView(
                  title: 'Something went wrong',
                  description: 'Could not load today\'s entry.',
                ),
                data: (_) => entry != null
                    ? TodayFilled(
                        entry: entry,
                        onTap: () => showEditEntrySheet(
                          context,
                          date: today,
                          existing: entry,
                        ),
                      )
                    : TodayEmpty(
                        onTap: () =>
                            showEditEntrySheet(context, date: today),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
