import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SettingsInfoRow extends StatelessWidget {
  const SettingsInfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: WdsSpacing.s16,
        vertical: WdsSpacing.s14,
      ),
      child: Row(
        children: [
          Expanded(child: WdsText(label, style: WdsTextStyle.body1)),
          Text(
            value,
            style: context.wdsType.body2.copyWith(color: colors.labelAssistive),
          ),
        ],
      ),
    );
  }
}
