import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/entry.dart';
import '../../../../core/providers/all_entries_provider.dart';

part 'search_providers.g.dart';

@riverpod
List<Entry> searchResults(Ref ref, String query) {
  if (query.isEmpty) return [];
  final all = ref.watch(allEntriesProvider).valueOrNull ?? [];
  final q = query.toLowerCase();
  return all.where((e) => e.text.toLowerCase().contains(q)).toList();
}
