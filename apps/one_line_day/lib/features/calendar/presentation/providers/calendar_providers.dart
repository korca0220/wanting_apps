import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/all_entries_provider.dart';

part 'calendar_providers.g.dart';

@riverpod
Set<String> datesWithEntries(Ref ref) {
  return ref
          .watch(allEntriesProvider)
          .valueOrNull
          ?.map((e) => e.date)
          .toSet() ??
      {};
}
