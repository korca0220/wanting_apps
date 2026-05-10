import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/preferences_repository_impl.dart';

part 'theme_mode_provider.g.dart';

/// Read by `app/app.dart` to drive `MaterialApp.themeMode`, mutated by the
/// settings screen. Persistence flows through `preferencesRepository` —
/// this controller doesn't know about SharedPreferences.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() => ref.read(preferencesRepositoryProvider).getThemeMode();

  Future<void> set(ThemeMode mode) async {
    state = mode;

    await ref.read(preferencesRepositoryProvider).setThemeMode(mode);
  }
}
