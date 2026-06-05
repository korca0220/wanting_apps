import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/hive_entry_repository.dart';
import '../domain/entities/entry.dart';
import '../domain/repositories/entry_repository.dart';

part 'all_entries_provider.g.dart';

@Riverpod(keepAlive: true)
class AllEntries extends _$AllEntries {
  EntryRepository get _repo => ref.read(entryRepositoryProvider);

  @override
  Future<List<Entry>> build() => _repo.getAll();

  Future<void> save(String date, String text) async {
    final existing = await _repo.getByDate(date);
    final now = DateTime.now();
    final entry = existing != null
        ? existing.copyWith(text: text, updatedAt: now)
        : Entry(
            id: newEntryId(),
            date: date,
            text: text,
            createdAt: now,
            updatedAt: now,
          );
    await _repo.save(entry);
    ref.invalidateSelf();
    await future;
  }

  Future<void> delete(String date) async {
    await _repo.delete(date);
    ref.invalidateSelf();
    await future;
  }
}
