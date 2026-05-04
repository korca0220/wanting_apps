import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WdsTheme.light registers all extensions', (tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      MaterialApp(
        theme: WdsTheme.light(),
        home: Builder(
          builder: (ctx) {
            capturedContext = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final theme = Theme.of(capturedContext);
    expect(theme.extension<WdsColorScheme>(), isNotNull);
    expect(theme.extension<WdsTypography>(), isNotNull);
    expect(theme.extension<WdsSpacingTheme>(), isNotNull);
    expect(theme.extension<WdsRadiusTheme>(), isNotNull);
    expect(theme.extension<WdsShadowsTheme>(), isNotNull);
    expect(theme.extension<WdsMotionTheme>(), isNotNull);
    expect(theme.brightness, Brightness.light);
  });

  testWidgets('WdsTheme.dark sets brightness and dark on-primary',
      (tester) async {
    late BuildContext capturedContext;
    await tester.pumpWidget(
      MaterialApp(
        theme: WdsTheme.dark(),
        home: Builder(
          builder: (ctx) {
            capturedContext = ctx;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    final theme = Theme.of(capturedContext);
    expect(theme.brightness, Brightness.dark);
    final colors = theme.extension<WdsColorScheme>()!;
    // Dark mode flips on-primary so AA contrast holds.
    expect(colors.onPrimary, isNot(equals(colors.staticWhite)));
  });

  testWidgets('BuildContext extension getters resolve', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: WdsTheme.light(),
        home: Builder(
          builder: (ctx) {
            // Just exercise each getter; resolution will throw if missing.
            ctx.wdsColors;
            ctx.wdsType;
            ctx.wdsSpacing;
            ctx.wdsRadius;
            ctx.wdsShadows;
            ctx.wdsMotion;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
