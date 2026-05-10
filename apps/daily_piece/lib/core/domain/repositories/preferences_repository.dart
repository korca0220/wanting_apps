import 'package:flutter/material.dart' show ThemeMode;

/// Domain port for user preferences. Currently just theme mode; new prefs add
/// new methods here (and a key in the impl). `ThemeMode` is reused from
/// flutter/material because every consumer eventually feeds it back into
/// `MaterialApp.themeMode` — re-defining a domain enum and mapping at every
/// boundary buys nothing for the cost.
abstract class PreferencesRepository {
  ThemeMode getThemeMode();

  Future<void> setThemeMode(ThemeMode mode);
}
