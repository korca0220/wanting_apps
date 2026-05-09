import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/app.dart';
import 'core/env/env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(
    Env.isConfigured,
    'SUPABASE_URL and SUPABASE_ANON_KEY must be passed via --dart-define. '
    'See apps/daily_piece/README.md.',
  );
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  runApp(const ProviderScope(child: DailyPieceApp()));
}
