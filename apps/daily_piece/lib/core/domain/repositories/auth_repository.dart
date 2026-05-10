/// Domain port for the auth lifecycle. Implementation in
/// `core/data/repositories/auth_repository_impl.dart` wraps Supabase Auth.
/// Throws [AuthFailure] (see `core/domain/exceptions/`) on auth-specific
/// errors; non-auth errors propagate as-is.
abstract class AuthRepository {
  /// Emits `true` when a session is present, `false` otherwise. Replays the
  /// current state on subscription so the router redirect can act on the
  /// first frame.
  Stream<bool> watchSignedIn();

  /// Snapshot of `watchSignedIn` for synchronous reads (router redirect).
  bool get isSignedIn;

  Future<void> signIn({required String email, required String password});

  /// `true` when the project has Confirm email = OFF (session granted
  /// immediately). `false` when a confirmation email was sent — the UI should
  /// then show a "check your inbox" state.
  Future<bool> signUp({required String email, required String password});

  Future<void> signOut();

  /// Sends a password reset email. The presentation layer should show a
  /// generic "if an account exists" success message regardless, so the
  /// account-existence side channel isn't exposed.
  Future<void> resetPassword({required String email});
}
