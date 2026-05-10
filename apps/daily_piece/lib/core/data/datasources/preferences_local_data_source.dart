import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'preferences_local_data_source.g.dart';

/// Bound at app start by `main.dart` after `SharedPreferences.getInstance()`
/// resolves — keeps the rest of the tree synchronous. Tests override this
/// with `SharedPreferences.setMockInitialValues({})`.
@Riverpod(keepAlive: true)
SharedPreferences sharedPreferences(Ref ref) => throw UnimplementedError(
  'sharedPreferencesProvider must be overridden in main.dart / tests',
);

@Riverpod(keepAlive: true)
PreferencesLocalDataSource preferencesLocalDataSource(Ref ref) =>
    PreferencesLocalDataSource(ref.watch(sharedPreferencesProvider));

/// Thin pipe to SharedPreferences — raw key/value access only. The repository
/// owns encoding to domain types and the canonical key strings.
class PreferencesLocalDataSource {
  PreferencesLocalDataSource(this._prefs);

  final SharedPreferences _prefs;

  String? getString(String key) => _prefs.getString(key);

  Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }
}
