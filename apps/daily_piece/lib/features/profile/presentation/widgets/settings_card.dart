import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_provider.dart';
import 'setting_row.dart';
import 'settings_section_card.dart';

/// Settings card — Export Data row + Theme row. Theme cycles through
/// System / Light / Dark on tap; the trailing label reflects the current
/// mode.
class SettingsCard extends ConsumerWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final mode = ref.watch(themeModeControllerProvider);

    return SettingsSectionCard(
      title: 'Settings',
      children: [
        SettingRow(
          icon: Icons.dark_mode_outlined,
          title: 'App Theme',
          caption: _label(mode),
          tone: SettingRowTone.neutral,
          trailing: Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Text(
              _trailingLabel(mode),
              style: TextStyle(color: colors.labelAlternative),
            ),
          ),
          onTap: () => ref
              .read(themeModeControllerProvider.notifier)
              .set(_next(mode)),
        ),
      ],
    );
  }
}

ThemeMode _next(ThemeMode m) => switch (m) {
  ThemeMode.system => ThemeMode.light,
  ThemeMode.light => ThemeMode.dark,
  ThemeMode.dark => ThemeMode.system,
};

String _label(ThemeMode m) => switch (m) {
  ThemeMode.system => 'Follows system',
  ThemeMode.light => 'Light mode',
  ThemeMode.dark => 'Dark mode',
};

String _trailingLabel(ThemeMode m) => switch (m) {
  ThemeMode.system => 'System',
  ThemeMode.light => 'Light',
  ThemeMode.dark => 'Dark',
};
