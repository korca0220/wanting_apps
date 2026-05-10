import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/preferences_repository.dart';
import '../datasources/preferences_local_data_source.dart';

part 'preferences_repository_impl.g.dart';

@Riverpod(keepAlive: true)
PreferencesRepository preferencesRepository(Ref ref) =>
    PreferencesRepositoryImpl(ref.watch(preferencesLocalDataSourceProvider));

class PreferencesRepositoryImpl implements PreferencesRepository {
  PreferencesRepositoryImpl(this._local);

  static const String _themeModeKey = 'themeMode';

  final PreferencesLocalDataSource _local;

  @override
  ThemeMode getThemeMode() {
    final stored = _local.getString(_themeModeKey);

    return ThemeMode.values.firstWhere(
      (m) => m.name == stored,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  Future<void> setThemeMode(ThemeMode mode) {
    return _local.setString(_themeModeKey, mode.name);
  }
}
