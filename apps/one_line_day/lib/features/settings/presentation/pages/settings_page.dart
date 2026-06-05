import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_controller.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.wdsSpacing;
    final themeMode = ref.watch(themeModeControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WdsText('Settings', style: WdsTextStyle.title2),
              SizedBox(height: spacing.componentLg),
              WdsText(
                'Appearance',
                style: WdsTextStyle.body2,
                color: WdsTextColor.alternative,
              ),
              SizedBox(height: spacing.componentSm),
              _ThemeOption(
                label: 'System',
                selected: themeMode == ThemeMode.system,
                onTap: () => ref
                    .read(themeModeControllerProvider.notifier)
                    .set(ThemeMode.system),
              ),
              _ThemeOption(
                label: 'Light',
                selected: themeMode == ThemeMode.light,
                onTap: () => ref
                    .read(themeModeControllerProvider.notifier)
                    .set(ThemeMode.light),
              ),
              _ThemeOption(
                label: 'Dark',
                selected: themeMode == ThemeMode.dark,
                onTap: () => ref
                    .read(themeModeControllerProvider.notifier)
                    .set(ThemeMode.dark),
              ),
              SizedBox(height: spacing.componentLg),
              const WdsDivider(),
              SizedBox(height: spacing.componentLg),
              WdsText(
                'About',
                style: WdsTextStyle.body2,
                color: WdsTextColor.alternative,
              ),
              SizedBox(height: spacing.componentSm),
              WdsListItem(
                content: const WdsText('Version', style: WdsTextStyle.body2),
                trailing: const WdsText(
                  '1.0.0',
                  style: WdsTextStyle.body2,
                  color: WdsTextColor.alternative,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  const _ThemeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return WdsListItem(
      content: WdsText(label, style: WdsTextStyle.body2),
      trailing: selected
          ? Icon(Icons.check, color: context.wdsColors.primaryNormal, size: 20)
          : null,
      onTap: onTap,
    );
  }
}
