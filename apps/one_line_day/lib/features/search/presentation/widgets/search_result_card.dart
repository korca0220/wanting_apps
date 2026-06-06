import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../edit_entry/presentation/widgets/edit_entry_sheet.dart';
import 'highlighted_text.dart';

class SearchResultCard extends StatelessWidget {
  const SearchResultCard({
    super.key,
    required this.entry,
    required this.dateLabel,
    required this.query,
  });

  final Entry entry;
  final String dateLabel;
  final String query;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return GestureDetector(
      onTap: () =>
          showEditEntrySheet(context, date: entry.date, existing: entry),
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
                  HighlightedText(text: entry.text, query: query),
                ],
              ),
            ),
            const SizedBox(width: WdsSpacing.s8),
            Icon(Icons.chevron_right, size: 18, color: colors.labelAssistive),
          ],
        ),
      ),
    );
  }
}
