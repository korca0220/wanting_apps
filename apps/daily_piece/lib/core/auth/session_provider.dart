import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Streams the current Supabase auth session. `null` means signed out.
///
/// Backed by `client.auth.onAuthStateChange`, which emits an
/// `initialSession` event on subscription so the first frame already
/// reflects whatever the persisted session was at app start.
final sessionProvider = StreamProvider<Session?>((ref) {
  final client = Supabase.instance.client;
  return client.auth.onAuthStateChange.map((event) => event.session);
});

/// Boolean projection used by the router redirect guard. Tests can
/// override this directly without touching Supabase at all.
final isSignedInProvider = Provider<bool>((ref) {
  final session = ref.watch(sessionProvider);
  return session.maybeWhen(data: (s) => s != null, orElse: () => false);
});
