import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.lineNormalNeutral),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: WdsText(title, style: WdsTextStyle.heading1),
          ),
          Container(height: 1, color: colors.lineNormalNeutral),
          ...children,
        ],
      ),
    );
  }
}
