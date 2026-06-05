import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../../core/providers/all_entries_provider.dart';
import '../../../edit_entry/presentation/widgets/edit_entry_sheet.dart';

class EntriesPage extends ConsumerWidget {
  const EntriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.wdsSpacing;
    final entriesAsync = ref.watch(allEntriesProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                spacing.componentLg,
                spacing.componentLg,
                spacing.componentLg,
                spacing.componentMd,
              ),
              child: WdsText('Entries', style: WdsTextStyle.title2),
            ),
            Expanded(
              child: entriesAsync.when(
                loading: () => const Center(child: WdsSpinner()),
                error: (_, _) => WdsFallbackView(
                  title: 'Something went wrong',
                  description: 'Could not load entries.',
                ),
                data: (entries) => entries.isEmpty
                    ? WdsFallbackView(
                        title: 'No entries yet',
                        description: 'Go to Today to write your first line.',
                      )
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(
                          horizontal: spacing.componentLg,
                          vertical: spacing.componentSm,
                        ),
                        itemCount: entries.length,
                        separatorBuilder: (_, _) =>
                            SizedBox(height: spacing.componentSm),
                        itemBuilder: (context, i) =>
                            _EntryCard(entry: entries[i]),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  const _EntryCard({required this.entry});

  final Entry entry;

  String get _dateLabel {
    final parts = entry.date.split('-');
    return '${parts[0]}. ${parts[1]}. ${parts[2]}';
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;

    return GestureDetector(
      onTap: () => showEditEntrySheet(
        context,
        date: entry.date,
        existing: entry,
      ),
      child: WdsCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WdsText(
                _dateLabel,
                style: WdsTextStyle.caption1,
                color: WdsTextColor.alternative,
              ),
              SizedBox(height: spacing.componentXs),
              WdsText(entry.text, style: WdsTextStyle.body2),
            ],
          ),
        ),
      ),
    );
  }
}
