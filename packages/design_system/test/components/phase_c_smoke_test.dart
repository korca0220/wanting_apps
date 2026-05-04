import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: WdsTheme.light(),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  testWidgets('WdsAlert.show renders title and actions', (tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(MaterialApp(
      theme: WdsTheme.light(),
      home: Builder(builder: (ctx) {
        capturedContext = ctx;
        return const Scaffold();
      }),
    ));

    bool? choice;
    final future = WdsAlert.show<bool>(
      context: capturedContext,
      title: 'Confirm?',
      description: 'Make sure.',
      actions: [
        WdsAlertAction(
          label: 'Cancel',
          variant: WdsAlertActionVariant.assistive,
          onPressed: () => Navigator.of(capturedContext).pop(false),
        ),
        WdsAlertAction(
          label: 'OK',
          onPressed: () => Navigator.of(capturedContext).pop(true),
        ),
      ],
    ).then((v) => choice = v);

    await tester.pumpAndSettle();
    expect(find.text('Confirm?'), findsOneWidget);
    expect(find.text('Make sure.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await future;
    expect(choice, isTrue);
  });

  testWidgets('WdsSnackbar.show shows a SnackBar with message', (tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(MaterialApp(
      theme: WdsTheme.light(),
      home: Scaffold(
        body: Builder(builder: (ctx) {
          capturedContext = ctx;
          return const SizedBox.shrink();
        }),
      ),
    ));

    WdsSnackbar.show(
      context: capturedContext,
      message: 'Saved!',
      variant: WdsSnackbarVariant.success,
    );
    await tester.pump(); // start animation
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('Saved!'), findsOneWidget);
  });

  testWidgets('WdsProgressTracker renders all steps', (tester) async {
    await tester.pumpWidget(_wrap(
      const SizedBox(
        width: 600,
        child: WdsProgressTracker(
          steps: ['One', 'Two', 'Three'],
          current: 1,
        ),
      ),
    ));
    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
  });

  testWidgets('WdsSkeleton renders without animation in reduced motion',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: WdsTheme.light(),
      home: const MediaQuery(
        data: MediaQueryData(disableAnimations: true),
        child: Scaffold(
          body: Center(child: WdsSkeleton(variant: WdsSkeletonVariant.text)),
        ),
      ),
    ));
    expect(find.byType(WdsSkeleton), findsOneWidget);
  });

  testWidgets('WdsFallbackView renders title/description/action',
      (tester) async {
    await tester.pumpWidget(_wrap(
      WdsFallbackView(
        title: 'Nothing here',
        description: 'Add your first piece.',
        action: WdsButton(onPressed: () {}, child: const Text('Add')),
      ),
    ));
    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Add your first piece.'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('WdsSelect changes value when item is tapped', (tester) async {
    String? value = 'a';
    await tester.pumpWidget(MaterialApp(
      theme: WdsTheme.light(),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 240,
            child: StatefulBuilder(builder: (ctx, set) {
              return WdsSelect<String>(
                value: value,
                items: const [
                  WdsSelectOption(value: 'a', label: 'Alpha'),
                  WdsSelectOption(value: 'b', label: 'Beta'),
                ],
                onChanged: (v) => set(() => value = v),
              );
            }),
          ),
        ),
      ),
    ));

    await tester.tap(find.text('Alpha').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Beta').last);
    await tester.pumpAndSettle();
    expect(value, 'b');
  });
}
