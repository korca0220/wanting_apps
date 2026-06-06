import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../edit_entry/presentation/widgets/edit_entry_sheet.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({super.key, required this.entry, required this.dateLabel});

  final Entry entry;
  final String dateLabel;

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
                  WdsText(entry.text, style: WdsTextStyle.body1),
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
