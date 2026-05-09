import 'package:envied/envied.dart';

part 'env.g.dart';

/// Build-time environment values, sourced from `apps/daily_piece/.env`
/// at codegen time and obfuscated into the binary.
///
/// Workflow:
/// 1. Copy `.env.example` to `.env` and fill values.
/// 2. Run `melos run gen` (or `dart run build_runner build --delete-conflicting-outputs`).
/// 3. `flutter run` — no `--dart-define` needed.
///
/// `.env` is gitignored. Never commit real keys.
@Envied(path: '.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static final String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static final String supabaseAnonKey = _Env.supabaseAnonKey;

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
