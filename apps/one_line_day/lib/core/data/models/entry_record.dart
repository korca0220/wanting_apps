import 'package:hive_ce_flutter/hive_flutter.dart';

part 'entry_record.g.dart';

@HiveType(typeId: 0)
class EntryRecord extends HiveObject {
  EntryRecord({
    required this.id,
    required this.date,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String text;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  DateTime updatedAt;
}
