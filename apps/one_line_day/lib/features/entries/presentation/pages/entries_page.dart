import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../../core/providers/all_entries_provider.dart';
import '../../../edit_entry/presentation/widgets/edit_entry_sheet.dart';

class EntriesPage extends ConsumerWidget {
  const EntriesPage({super.key});

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static const _monthsShort = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  String _cardDate(String dateStr) {
    final parts = dateStr.split('-');
    final d = DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
    return '${_weekdays[d.weekday - 1]}, ${_monthsShort[d.month - 1]} ${d.day}';
  }

  String _monthHeader(String yyyyMM) {
    final parts = yyyyMM.split('-');
    return '${_months[int.parse(parts[1]) - 1]} ${parts[0]}';
  }

  List<_Section> _group(List<Entry> entries) {
    final map = <String, List<Entry>>{};
    for (final e in entries) {
      final key = e.date.substring(0, 7);
      map.putIfAbsent(key, () => []).add(e);
    }
    return map.entries
        .map((e) => _Section(month: e.key, entries: e.value))
        .toList()
      ..sort((a, b) => b.month.compareTo(a.month));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final entriesAsync = ref.watch(allEntriesProvider);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: entriesAsync.when(
          loading: () => const Center(child: WdsSpinner()),
          error: (_, _) => WdsFallbackView(
            title: 'Something went wrong',
            description: 'Could not load entries.',
          ),
          data: (entries) {
            if (entries.isEmpty) {
              return WdsFallbackView(
                title: 'No entries yet',
                description: 'Write your first line on the Today tab.',
              );
            }
            final sections = _group(entries);
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      spacing.componentLg,
                      spacing.componentLg,
                      spacing.componentLg,
                      WdsSpacing.s4,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        WdsText('Entries', style: WdsTextStyle.title2),
                        const SizedBox(width: WdsSpacing.s8),
                        WdsText(
                          '${entries.length}',
                          style: WdsTextStyle.body2,
                          color: WdsTextColor.alternative,
                        ),
                      ],
                    ),
                  ),
                ),
                for (final section in sections) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        spacing.componentLg,
                        WdsSpacing.s24,
                        spacing.componentLg,
                        WdsSpacing.s8,
                      ),
                      child: WdsText(
                        _monthHeader(section.month),
                        style: WdsTextStyle.label1,
                        color: WdsTextColor.alternative,
                      ),
                    ),
                  ),
                  SliverList.separated(
                    itemCount: section.entries.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: WdsSpacing.s8),
                    itemBuilder: (context, i) => Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: spacing.componentLg,
                      ),
                      child: _EntryCard(
                        entry: section.entries[i],
                        dateLabel: _cardDate(section.entries[i].date),
                      ),
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: WdsSpacing.s32)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Section {
  const _Section({required this.month, required this.entries});
  final String month;
  final List<Entry> entries;
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry, required this.dateLabel});

  final Entry entry;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return GestureDetector(
      onTap: () => showEditEntrySheet(context, date: entry.date, existing: entry),
      child: Container(
        decoration: BoxDecoration(
          color: colors.backgroundElevatedNormal,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(WdsSpacing.s16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WdsText(
                    dateLabel,
                    style: WdsTextStyle.caption1,
                    color: WdsTextColor.alternative,
                  ),
                  const SizedBox(height: WdsSpacing.s6),
                  WdsText(entry.text, style: WdsTextStyle.body1),
                ],
              ),
            ),
            const SizedBox(width: WdsSpacing.s8),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: colors.labelAssistive,
            ),
          ],
        ),
      ),
    );
  }
}
