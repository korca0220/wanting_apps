import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/repositories/auth_repository_impl.dart';

part 'session_provider.g.dart';

/// Stream of "is the user signed in?" — flows through [AuthRepository] so
/// presentation never touches Supabase types directly. `keepAlive` because
/// auth state should outlive any single screen.
@Riverpod(keepAlive: true)
Stream<bool> signedInStream(Ref ref) {
  return ref.watch(authRepositoryProvider).watchSignedIn();
}

/// Synchronous projection used by the router redirect guard. Tests can
/// override this directly without touching Supabase at all.
@Riverpod(keepAlive: true)
bool isSignedIn(Ref ref) {
  return ref
      .watch(signedInStreamProvider)
      .maybeWhen(data: (v) => v, orElse: () => false);
}
