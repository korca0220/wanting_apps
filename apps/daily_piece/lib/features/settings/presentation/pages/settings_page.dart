import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/sign_out_tile.dart';
import '../widgets/theme_mode_section.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('설정')),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: spacing.componentMd),
            const ThemeModeSection(),
            SizedBox(height: spacing.componentLg),
            const Divider(height: 1),
            const SignOutTile(),
          ],
        ),
      ),
    );
  }
}
