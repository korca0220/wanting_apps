import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SearchHint extends StatelessWidget {
  const SearchHint({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search, size: 40, color: colors.labelAssistive),
          const SizedBox(height: WdsSpacing.s12),
          const WdsText(
            'Type a keyword',
            style: WdsTextStyle.body1,
            color: WdsTextColor.alternative,
          ),
          const SizedBox(height: WdsSpacing.s4),
          const WdsText(
            'Find entries by words you remember',
            style: WdsTextStyle.caption1,
            color: WdsTextColor.disable,
          ),
        ],
      ),
    );
  }
}
