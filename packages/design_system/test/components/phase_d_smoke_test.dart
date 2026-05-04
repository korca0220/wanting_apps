import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
      theme: WdsTheme.light(),
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  testWidgets('WdsTextField renders label/placeholder and reports onChanged',
      (tester) async {
    String? captured;
    await tester.pumpWidget(_wrap(
      WdsTextField(
        label: 'Email',
        placeholder: 'name@example.com',
        onChanged: (v) => captured = v,
      ),
    ));
    expect(find.text('Email'), findsWidgets);
    await tester.enterText(find.byType(TextField), 'a@b.com');
    expect(captured, 'a@b.com');
  });

  testWidgets('WdsTextField clearable shows reset and clears value',
      (tester) async {
    final ctrl = TextEditingController(text: 'hello');
    await tester.pumpWidget(_wrap(
      WdsTextField(controller: ctrl, clearable: true),
    ));
    expect(find.byIcon(Icons.cancel), findsOneWidget);
    await tester.tap(find.byIcon(Icons.cancel));
    await tester.pump();
    expect(ctrl.text, '');
  });

  testWidgets('WdsTextarea grows to multi-line', (tester) async {
    await tester.pumpWidget(_wrap(
      const SizedBox(width: 300, child: WdsTextarea(minLines: 3)),
    ));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.minLines, 3);
    expect(field.keyboardType, TextInputType.multiline);
  });

  testWidgets('WdsTooltip renders the wrapped child', (tester) async {
    await tester.pumpWidget(_wrap(
      const WdsTooltip(message: 'Hint', child: Icon(Icons.info)),
    ));
    expect(find.byIcon(Icons.info), findsOneWidget);
  });

  testWidgets('WdsModal.showPopup displays slot content', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      theme: WdsTheme.light(),
      home: Scaffold(body: Builder(builder: (c) {
        ctx = c;
        return const SizedBox.shrink();
      })),
    ));

    WdsModal.showPopup<void>(
      context: ctx,
      builder: (_) => const Padding(
        padding: EdgeInsets.all(16),
        child: Text('Hello popup'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Hello popup'), findsOneWidget);
  });

  testWidgets('WdsCard composes title/caption inside a content slot',
      (tester) async {
    await tester.pumpWidget(_wrap(
      const SizedBox(
        width: 320,
        child: WdsCard(
          child: WdsCardContent(
            children: [
              WdsCardTitle('Title'),
              WdsCardCaption('Caption text'),
            ],
          ),
        ),
      ),
    ));
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Caption text'), findsOneWidget);
  });
}
