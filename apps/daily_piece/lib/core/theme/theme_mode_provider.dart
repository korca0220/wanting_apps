import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_mode_provider.g.dart';

/// Bound at app start by `main.dart` after `SharedPreferences.getInstance()`
/// resolves — keeps the rest of the tree synchronous.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) =>
    throw UnimplementedError('Override in main.dart');

const _key = 'themeMode';

/// User's theme preference. Persisted via SharedPreferences so the choice
/// survives app restarts. `system` follows the OS setting.
@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_key);

    return _decode(stored);
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;

    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, _encode(mode));
  }
}

ThemeMode _decode(String? s) {
  switch (s) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

String _encode(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.light:
      return 'light';
    case ThemeMode.dark:
      return 'dark';
    case ThemeMode.system:
      return 'system';
  }
}
