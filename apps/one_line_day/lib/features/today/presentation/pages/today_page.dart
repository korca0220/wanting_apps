import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/all_entries_provider.dart';
import '../../../../core/utils/date_key.dart';
import '../../../edit_entry/presentation/widgets/edit_entry_sheet.dart';
import '../providers/today_providers.dart';
import '../widgets/today_entry_card.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  String get _todayLabel {
    final now = DateTime.now();
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.wdsSpacing;
    final today = dateKey(DateTime.now());
    final entriesAsync = ref.watch(allEntriesProvider);
    final entry = ref.watch(todayEntryProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WdsText('Today', style: WdsTextStyle.title2),
              SizedBox(height: spacing.componentXs),
              WdsText(
                _todayLabel,
                style: WdsTextStyle.body2,
                color: WdsTextColor.alternative,
              ),
              SizedBox(height: spacing.componentLg),
              entriesAsync.when(
                loading: () => const Center(child: WdsSpinner()),
                error: (_, _) => WdsFallbackView(
                  title: 'Something went wrong',
                  description: 'Could not load today\'s entry.',
                ),
                data: (_) => entry != null
                    ? TodayEntryCard(
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
            ],
          ),
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
      onTap: onTap,
      child: WdsCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WdsText(
                'How was today?',
                style: WdsTextStyle.body1,
                color: WdsTextColor.alternative,
              ),
              SizedBox(height: spacing.componentSm),
              WdsText(
                'Tap to write one line',
                style: WdsTextStyle.caption1,
                color: WdsTextColor.disable,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
