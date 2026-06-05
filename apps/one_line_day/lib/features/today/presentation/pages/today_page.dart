import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../../core/providers/all_entries_provider.dart';
import '../../../../core/utils/date_key.dart';
import '../../../edit_entry/presentation/widgets/edit_entry_sheet.dart';
import '../providers/today_providers.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  static const _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String _weekday(DateTime d) => _weekdays[d.weekday - 1];
  String _dateLabel(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

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
                error: (_, _) => WdsFallbackView(
                  title: 'Something went wrong',
                  description: 'Could not load today\'s entry.',
                ),
                data: (_) => entry != null
                    ? _FilledToday(
                        entry: entry,
                        onTap: () => showEditEntrySheet(
                          context,
                          date: today,
                          existing: entry,
                        ),
                      )
                    : _EmptyToday(
                        onTap: () => showEditEntrySheet(context, date: today),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyToday extends StatelessWidget {
  const _EmptyToday({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.backgroundNormalAlternative,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: colors.labelAlternative,
                  size: 22,
                ),
              ),
              const SizedBox(height: WdsSpacing.s16),
              WdsText(
                'How was today?',
                style: WdsTextStyle.headline1,
                color: WdsTextColor.neutral,
              ),
              const SizedBox(height: WdsSpacing.s8),
              WdsText(
                'Tap to write one line',
                style: WdsTextStyle.body2,
                color: WdsTextColor.disable,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilledToday extends StatelessWidget {
  const _FilledToday({required this.entry, required this.onTap});

  final Entry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.componentLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: spacing.componentLg),
            IntrinsicHeight(
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
            SizedBox(height: spacing.componentLg),
            Row(
              children: [
                Icon(Icons.edit_outlined, size: 14, color: colors.labelAssistive),
                const SizedBox(width: WdsSpacing.s4),
                WdsText(
                  'Tap to edit',
                  style: WdsTextStyle.caption1,
                  color: WdsTextColor.assistive,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
