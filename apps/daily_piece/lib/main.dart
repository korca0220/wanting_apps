import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/env/env.dart';
import 'core/theme/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(
    Env.isConfigured,
    'SUPABASE_URL and SUPABASE_ANON_KEY must be set in apps/daily_piece/.env '
    '(copy .env.example) and codegen must be run (melos run gen). '
    'See apps/daily_piece/README.md.',
  );

  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const DailyPieceApp(),
    ),
  );
}
