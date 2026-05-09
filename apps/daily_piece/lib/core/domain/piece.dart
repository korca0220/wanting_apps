import 'package:flutter/foundation.dart';

/// A single archived moment — photo + ≤50-char comment + date.
/// Domain invariant: at most one Piece per local calendar day.
@immutable
class Piece {
  const Piece({
    required this.id,
    required this.photoUri,
    required this.comment,
    required this.date,
  }) : assert(
         comment.length <= commentMaxLength,
         'comment > $commentMaxLength chars',
       );

  static const int commentMaxLength = 50;

  final String id;
  final Uri photoUri;
  final String comment;
  final DateTime date;
}
