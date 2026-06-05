class Entry {
  const Entry({
    required this.id,
    required this.date,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String date; // yyyy-MM-dd
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  Entry copyWith({String? text, DateTime? updatedAt}) => Entry(
        id: id,
        date: date,
        text: text ?? this.text,
        createdAt: createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
}
