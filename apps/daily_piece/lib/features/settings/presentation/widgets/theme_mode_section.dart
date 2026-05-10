import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/theme_mode_provider.dart';

/// Three-option theme switcher (System / Light / Dark). Persisted via
/// SharedPreferences inside the controller.
class ThemeModeSection extends ConsumerWidget {
  const ThemeModeSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.wdsSpacing;
    final mode = ref.watch(themeModeControllerProvider);
    final controller = ref.read(themeModeControllerProvider.notifier);

    return RadioGroup<ThemeMode>(
      groupValue: mode,
      onChanged: (next) {
        if (next != null) controller.set(next);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.componentXl),
            child: const WdsText('테마', style: WdsTextStyle.headline2),
          ),
          SizedBox(height: spacing.componentSm),
          for (final option in ThemeMode.values)
            RadioListTile<ThemeMode>(
              title: Text(_label(option)),
              value: option,
            ),
        ],
      ),
    );
  }
}

String _label(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.system:
      return '시스템 설정 따르기';
    case ThemeMode.light:
      return '라이트';
    case ThemeMode.dark:
      return '다크';
  }
}
