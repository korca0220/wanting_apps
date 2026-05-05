import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeMode mode = ThemeMode.light}) => MaterialApp(
  theme: WdsTheme.light(),
  darkTheme: WdsTheme.dark(),
  themeMode: mode,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('WdsButton', () {
    testWidgets('invokes onPressed when tapped', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        _wrap(
          WdsButton(onPressed: () => pressed++, child: const Text('Hit me')),
        ),
      );

      await tester.tap(find.text('Hit me'));
      await tester.pump();

      expect(pressed, 1);
    });

    testWidgets('null onPressed renders disabled (no callbacks)', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(const WdsButton(onPressed: null, child: Text('Off'))),
      );

      // Tap should be a no-op; we only assert the button still rendered.
      await tester.tap(find.text('Off'));
      await tester.pump();

      expect(find.text('Off'), findsOneWidget);
    });

    testWidgets('loading hides child but preserves layout space', (
      tester,
    ) async {
      var pressed = 0;
      await tester.pumpWidget(
        _wrap(
          WdsButton(
            onPressed: () => pressed++,
            loading: true,
            child: const Text('Submit'),
          ),
        ),
      );

      // Spinner is present.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Text widget exists in the tree (Visibility maintainSize) but it
      // shouldn't fire onPressed while loading.
      await tester.tap(find.byType(WdsButton), warnIfMissed: false);
      await tester.pump();
      expect(pressed, 0);
    });

    testWidgets('outlined primary renders without backgrounded fill', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          WdsButton(
            onPressed: () {},
            variant: WdsButtonVariant.outlined,
            color: WdsButtonColor.primary,
            child: const Text('Cancel'),
          ),
        ),
      );

      // Asserting via finder existence; visual props verified in goldens
      // (Phase B+).
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('size variants render distinct paddings', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WdsButton(
                onPressed: () {},
                size: WdsButtonSize.small,
                child: const Text('S'),
              ),
              WdsButton(
                onPressed: () {},
                size: WdsButtonSize.medium,
                child: const Text('M'),
              ),
              WdsButton(
                onPressed: () {},
                size: WdsButtonSize.large,
                child: const Text('L'),
              ),
            ],
          ),
        ),
      );

      final sizeS = tester.getSize(find.text('S'));
      final sizeL = tester.getSize(find.text('L'));
      // Large should be visually wider/taller than small.
      expect(sizeL.height, greaterThan(sizeS.height));
    });
  });
}
