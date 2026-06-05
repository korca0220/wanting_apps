import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'app/app.dart';
import 'core/data/models/entry_record.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EntryRecordAdapter());
  await Hive.openBox<EntryRecord>('entries');
  await Hive.openBox<dynamic>('settings');
  runApp(const ProviderScope(child: OneLineDayApp()));
}
