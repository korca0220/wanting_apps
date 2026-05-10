/// Thrown when INSERT collides with the UNIQUE(user_id, date) constraint —
/// i.e. the user already saved a Piece for today.
class PieceAlreadyExistsToday implements Exception {
  const PieceAlreadyExistsToday();
  @override
  String toString() => 'PieceAlreadyExistsToday';
}
