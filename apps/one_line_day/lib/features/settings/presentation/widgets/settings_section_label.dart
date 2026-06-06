import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class SettingsSectionLabel extends StatelessWidget {
  const SettingsSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: WdsSpacing.s4),
      child: WdsText(
        label.toUpperCase(),
        style: WdsTextStyle.caption1,
        color: WdsTextColor.alternative,
      ),
    );
  }
}
