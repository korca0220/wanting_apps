import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../../core/providers/all_entries_provider.dart';
import '../../../../core/utils/date_key.dart';

part 'today_providers.g.dart';

@riverpod
Entry? todayEntry(Ref ref) {
  final today = dateKey(DateTime.now());
  final all = ref.watch(allEntriesProvider).valueOrNull ?? [];
  for (final e in all) {
    if (e.date == today) return e;
  }
  return null;
}
