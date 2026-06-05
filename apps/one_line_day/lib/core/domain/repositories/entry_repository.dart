import '../entities/entry.dart';

abstract class EntryRepository {
  Future<Entry?> getByDate(String date);
  Future<List<Entry>> getAll();
  Future<void> save(Entry entry);
  Future<void> delete(String date);
}
