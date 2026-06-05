import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_controller.dart';

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
            Padding(
              padding: const EdgeInsets.only(
                bottom: WdsSpacing.s20,
                left: WdsSpacing.s4,
              ),
              child: WdsText('Settings', style: WdsTextStyle.title2),
            ),
            _SectionLabel(label: 'Appearance'),
            const SizedBox(height: WdsSpacing.s8),
            _SectionCard(
              children: [
                _ThemeOption(
                  label: 'System',
                  selected: themeMode == ThemeMode.system,
                  onTap: () => ref
                      .read(themeModeControllerProvider.notifier)
                      .set(ThemeMode.system),
                ),
                const WdsDivider(),
                _ThemeOption(
                  label: 'Light',
                  selected: themeMode == ThemeMode.light,
                  onTap: () => ref
                      .read(themeModeControllerProvider.notifier)
                      .set(ThemeMode.light),
                ),
                const WdsDivider(),
                _ThemeOption(
                  label: 'Dark',
                  selected: themeMode == ThemeMode.dark,
                  onTap: () => ref
                      .read(themeModeControllerProvider.notifier)
                      .set(ThemeMode.dark),
                ),
              ],
            ),
            const SizedBox(height: WdsSpacing.s24),
            _SectionLabel(label: 'About'),
            const SizedBox(height: WdsSpacing.s8),
            _SectionCard(
              children: [
                _InfoRow(label: 'Version', value: '1.0.0'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

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

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundNormalNormal,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
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
            Expanded(
              child: WdsText(label, style: WdsTextStyle.body1),
            ),
            if (selected)
              Icon(Icons.check_rounded, size: 20, color: colors.primaryNormal),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

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
