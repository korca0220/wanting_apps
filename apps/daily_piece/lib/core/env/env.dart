/// Build-time environment values, supplied via `--dart-define`.
///
/// Example: `flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co
/// --dart-define=SUPABASE_ANON_KEY=eyJ...`.
///
/// Both keys must be present at runtime — `main()` asserts this so misconfigured
/// builds fail loudly rather than crashing later inside Supabase calls.
class Env {
  const Env._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
