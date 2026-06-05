import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_controller.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  static const _key = 'themeMode';

  Box get _box => Hive.box('settings');

  @override
  ThemeMode build() {
    final stored = _box.get(_key, defaultValue: 'system') as String;
    return _fromString(stored);
  }

  Future<void> set(ThemeMode mode) async {
    state = mode;
    await _box.put(_key, _toString(mode));
  }

  ThemeMode _fromString(String s) => switch (s) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  String _toString(ThemeMode m) => switch (m) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    _ => 'system',
  };
}
