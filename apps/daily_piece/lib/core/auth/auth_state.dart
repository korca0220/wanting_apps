import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Authentication snapshot. Replaced by a real auth integration once the
/// backend ADR lands; stays loosely-typed on purpose so screens can wire
/// against `isSignedIn` without committing to a session shape yet.
class AuthState {
  const AuthState({required this.isSignedIn});

  const AuthState.signedOut() : isSignedIn = false;

  final bool isSignedIn;
}

final authProvider = StateProvider<AuthState>(
  (ref) => const AuthState.signedOut(),
);
