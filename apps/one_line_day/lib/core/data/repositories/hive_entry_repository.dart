import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/entry.dart';
import '../../domain/repositories/entry_repository.dart';
import '../models/entry_record.dart';

part 'hive_entry_repository.g.dart';

@Riverpod(keepAlive: true)
EntryRepository entryRepository(Ref ref) => _HiveEntryRepository();

class _HiveEntryRepository implements EntryRepository {
  static const _boxName = 'entries';

  Box<EntryRecord> get _box => Hive.box<EntryRecord>(_boxName);

  @override
  Future<Entry?> getByDate(String date) async {
    return _box.get(date)?.toEntry();
  }

  @override
  Future<List<Entry>> getAll() async {
    return _box.values.map((r) => r.toEntry()).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> save(Entry entry) async {
    await _box.put(
      entry.date,
      EntryRecord(
        id: entry.id,
        date: entry.date,
        text: entry.text,
        createdAt: entry.createdAt,
        updatedAt: entry.updatedAt,
      ),
    );
  }

  @override
  Future<void> delete(String date) async {
    await _box.delete(date);
  }
}

extension on EntryRecord {
  Entry toEntry() => Entry(
        id: id,
        date: date,
        text: text,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

const _uuid = Uuid();
String newEntryId() => _uuid.v4();
