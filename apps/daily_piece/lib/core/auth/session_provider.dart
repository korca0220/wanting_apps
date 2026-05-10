import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'session_provider.g.dart';

/// Streams the current Supabase auth session. `null` means signed out.
///
/// `onAuthStateChange` emits an `initialSession` event on subscription so
/// the first frame already reflects whatever session was persisted at app
/// start. `keepAlive` because auth state should outlive any single screen.
@Riverpod(keepAlive: true)
Stream<Session?> session(Ref ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map(
    (event) => event.session,
  );
}

/// Boolean projection used by the router redirect guard. Tests can
/// override this directly without touching Supabase at all.
@Riverpod(keepAlive: true)
bool isSignedIn(Ref ref) {
  return ref
      .watch(sessionProvider)
      .maybeWhen(data: (s) => s != null, orElse: () => false);
}
