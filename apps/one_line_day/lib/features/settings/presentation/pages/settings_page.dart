import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_controller.dart';
import '../widgets/settings_info_row.dart';
import '../widgets/settings_section_card.dart';
import '../widgets/settings_section_label.dart';
import '../widgets/settings_theme_option.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final themeMode = ref.watch(themeModeControllerProvider);

    return Scaffold(
      backgroundColor: colors.backgroundNormalAlternative,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.componentLg),
          children: [
            const Padding(
              padding: EdgeInsets.only(
                bottom: WdsSpacing.s20,
                left: WdsSpacing.s4,
              ),
              child: WdsText('Settings', style: WdsTextStyle.title2),
            ),
            const SettingsSectionLabel(label: 'Appearance'),
            const SizedBox(height: WdsSpacing.s8),
            SettingsSectionCard(
              children: [
                SettingsThemeOption(
                  label: 'System',
                  selected: themeMode == ThemeMode.system,
                  onTap: () => ref
                      .read(themeModeControllerProvider.notifier)
                      .set(ThemeMode.system),
                ),
                const WdsDivider(),
                SettingsThemeOption(
                  label: 'Light',
                  selected: themeMode == ThemeMode.light,
                  onTap: () => ref
                      .read(themeModeControllerProvider.notifier)
                      .set(ThemeMode.light),
                ),
                const WdsDivider(),
                SettingsThemeOption(
                  label: 'Dark',
                  selected: themeMode == ThemeMode.dark,
                  onTap: () => ref
                      .read(themeModeControllerProvider.notifier)
                      .set(ThemeMode.dark),
                ),
              ],
            ),
            const SizedBox(height: WdsSpacing.s24),
            const SettingsSectionLabel(label: 'About'),
            const SizedBox(height: WdsSpacing.s8),
            const SettingsSectionCard(
              children: [SettingsInfoRow(label: 'Version', value: '1.0.0')],
            ),
          ],
        ),
      ),
    );
  }
}
