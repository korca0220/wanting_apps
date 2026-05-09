import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeMode mode = ThemeMode.light}) => MaterialApp(
  theme: WdsTheme.light(),
  darkTheme: WdsTheme.dark(),
  themeMode: mode,
  home: Scaffold(body: Center(child: child)),
);

TextStyle _styleOf(WidgetTester tester, String text) =>
    tester.widget<Text>(find.text(text)).style!;

void main() {
  testWidgets('default WdsText uses body1 + labelNormal', (tester) async {
    await tester.pumpWidget(_wrap(const WdsText('hi')));
    final style = _styleOf(tester, 'hi');
    expect(style.fontSize, 16);
    final colors = WdsColorScheme.light();
    expect(style.color, colors.labelNormal);
  });

  testWidgets('style enum maps to the matching scale', (tester) async {
    await tester.pumpWidget(
      _wrap(const WdsText('huge', style: WdsTextStyle.display1)),
    );
    expect(_styleOf(tester, 'huge').fontSize, 56);
  });

  testWidgets('color enum resolves to the right semantic role', (tester) async {
    await tester.pumpWidget(
      _wrap(const WdsText('muted', color: WdsTextColor.alternative)),
    );
    final colors = WdsColorScheme.light();
    expect(_styleOf(tester, 'muted').color, colors.labelAlternative);
  });

  testWidgets('bold promotes to w700 for display/title scales', (tester) async {
    await tester.pumpWidget(
      _wrap(const WdsText('big', style: WdsTextStyle.title1, bold: true)),
    );
    expect(_styleOf(tester, 'big').fontWeight, FontWeight.w700);
  });

  testWidgets('bold promotes to w600 for non-display scales', (tester) async {
    await tester.pumpWidget(
      _wrap(const WdsText('mid', style: WdsTextStyle.body1, bold: true)),
    );
    expect(_styleOf(tester, 'mid').fontWeight, FontWeight.w600);
  });

  testWidgets('colorOverride wins over color enum', (tester) async {
    const override = Color(0xFFAA00AA);
    await tester.pumpWidget(
      _wrap(
        const WdsText(
          'override',
          color: WdsTextColor.primary,
          colorOverride: override,
        ),
      ),
    );
    expect(_styleOf(tester, 'override').color, override);
  });

  testWidgets('color follows brightness in dark mode', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const WdsText('dark', color: WdsTextColor.normal),
        mode: ThemeMode.dark,
      ),
    );
    final colors = WdsColorScheme.dark();
    expect(_styleOf(tester, 'dark').color, colors.labelNormal);
  });
}
