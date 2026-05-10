import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Stub. Implementation lands in the Calendar step of the renewal —
/// see docs/screens/03-calendar.md.
class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('Calendar')),
      body: const Center(
        child: WdsText('Coming soon', style: WdsTextStyle.body1),
      ),
    );
  }
}
