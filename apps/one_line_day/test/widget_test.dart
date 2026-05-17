import 'package:flutter_test/flutter_test.dart';
import 'package:one_line_day/main.dart';

void main() {
  testWidgets('shows OneLine Day home placeholder', (tester) async {
    await tester.pumpWidget(const OneLineDayApp());

    expect(find.text('OneLine Day'), findsOneWidget);
    expect(find.text('오늘을 한 줄로 남기는 앱'), findsOneWidget);
    expect(find.text('Save today'), findsOneWidget);
  });
}
