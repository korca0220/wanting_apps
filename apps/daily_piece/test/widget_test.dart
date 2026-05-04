import 'package:daily_piece/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Tapping WdsButton increments counter', (tester) async {
    await tester.pumpWidget(const DailyPieceApp());

    expect(find.text('Pressed 0 times'), findsOneWidget);

    await tester.tap(find.text('Tap me'));
    await tester.pump();

    expect(find.text('Pressed 1 time'), findsOneWidget);
  });
}
