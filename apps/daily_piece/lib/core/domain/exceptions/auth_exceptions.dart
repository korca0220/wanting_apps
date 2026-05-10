/// Domain-level wrapper around auth failures (sign in / sign up). Carries
/// only a user-facing message — UI shows it inline. Sub-types are deferred
/// until a screen actually needs to branch on cause.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => 'AuthFailure: $message';
}
