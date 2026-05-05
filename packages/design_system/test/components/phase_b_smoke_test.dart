import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: WdsTheme.light(),
  home: Scaffold(body: Center(child: child)),
);

void main() {
  testWidgets('WdsIconButton fires onPressed', (tester) async {
    var hits = 0;
    await tester.pumpWidget(
      _wrap(
        WdsIconButton(
          onPressed: () => hits++,
          semanticLabel: 'Add',
          icon: const Icon(Icons.add),
        ),
      ),
    );
    await tester.tap(find.byType(WdsIconButton));
    await tester.pump();
    expect(hits, 1);
  });

  testWidgets('WdsCheckbox toggles via onChanged', (tester) async {
    bool? value = false;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (ctx, set) => WdsCheckbox(
            value: value,
            label: 'Accept',
            onChanged: (v) => set(() => value = v),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(WdsCheckbox));
    await tester.pump();
    expect(value, isTrue);
  });

  testWidgets('WdsRadio changes group selection', (tester) async {
    var group = 'a';
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (ctx, set) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              WdsRadio<String>(
                value: 'a',
                groupValue: group,
                label: 'A',
                onChanged: (v) => set(() => group = v ?? 'a'),
              ),
              WdsRadio<String>(
                value: 'b',
                groupValue: group,
                label: 'B',
                onChanged: (v) => set(() => group = v ?? 'b'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('B'));
    await tester.pump();
    expect(group, 'b');
  });

  testWidgets('WdsSwitch toggles value', (tester) async {
    var on = false;
    await tester.pumpWidget(
      _wrap(
        StatefulBuilder(
          builder: (ctx, set) =>
              WdsSwitch(value: on, onChanged: (v) => set(() => on = v)),
        ),
      ),
    );
    await tester.tap(find.byType(WdsSwitch));
    await tester.pump();
    expect(on, isTrue);
  });

  testWidgets('WdsDivider renders', (tester) async {
    await tester.pumpWidget(
      _wrap(const SizedBox(width: 100, child: WdsDivider())),
    );
    expect(find.byType(WdsDivider), findsOneWidget);
  });

  testWidgets('WdsBadge renders label', (tester) async {
    await tester.pumpWidget(_wrap(const WdsBadge(label: 'NEW')));
    expect(find.text('NEW'), findsOneWidget);
  });

  testWidgets('WdsLabel adds asterisk when required', (tester) async {
    await tester.pumpWidget(
      _wrap(const WdsLabel(text: 'Email', required: true)),
    );
    expect(find.textContaining('*'), findsOneWidget);
  });

  testWidgets('WdsAvatar fallback renders icon when no image/initials', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const WdsAvatar()));
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('WdsAvatar renders initials when supplied', (tester) async {
    await tester.pumpWidget(_wrap(const WdsAvatar(initials: 'JW')));
    expect(find.text('JW'), findsOneWidget);
  });

  testWidgets('WdsSpinner renders a CircularProgressIndicator', (tester) async {
    await tester.pumpWidget(_wrap(const WdsSpinner()));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
