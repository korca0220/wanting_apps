import 'package:design_system_example/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Showcase boots and renders the Solid Primary section',
      (tester) async {
    await tester.pumpWidget(const ShowcaseApp());

    expect(find.text('Wanted DS — Showcase'), findsOneWidget);
    expect(find.text('Button — Solid Primary'), findsOneWidget);
    expect(find.text('Small'), findsWidgets);
  });
}
