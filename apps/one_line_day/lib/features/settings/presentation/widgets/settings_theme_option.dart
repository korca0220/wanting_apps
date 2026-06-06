import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SettingsThemeOption extends StatelessWidget {
  const SettingsThemeOption({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: WdsSpacing.s16,
          vertical: WdsSpacing.s14,
        ),
        child: Row(
          children: [
            Expanded(child: WdsText(label, style: WdsTextStyle.body1)),
            if (selected)
              Icon(Icons.check_rounded, size: 20, color: colors.primaryNormal),
          ],
        ),
      ),
    );
  }
}
