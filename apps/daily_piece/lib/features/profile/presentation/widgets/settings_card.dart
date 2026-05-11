import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_provider.dart';
import 'setting_row.dart';

/// Settings card — Export Data row + Theme row. Theme cycles through
/// System / Light / Dark on tap; the trailing label reflects the current
/// mode.
class SettingsCard extends ConsumerWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final mode = ref.watch(themeModeControllerProvider);

    return _Card(
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

class _Card extends StatelessWidget {
  const _Card({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.lineNormalNeutral),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: WdsText(title, style: WdsTextStyle.heading1),
          ),
          Container(height: 1, color: colors.lineNormalNeutral),
          ...children,
        ],
      ),
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
