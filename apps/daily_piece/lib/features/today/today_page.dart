import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('Today')),
      body: const Center(
        child: WdsText(
          "Today's Piece — TODO",
          style: WdsTextStyle.headline2,
          color: WdsTextColor.alternative,
        ),
      ),
    );
  }
}
