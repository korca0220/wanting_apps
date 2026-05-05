@Tags(['golden'])
library;

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Goldens are baselined locally on macOS. CI must run with the same
/// platform / font stack, or the comparison will trip on rasterization
/// differences. To regenerate baselines after intentional visual changes:
///
///   flutter test --update-goldens test/components/golden/golden_test.dart
///
/// Coverage is intentionally narrow — one matrix-style sample per
/// component, captured in light + dark — to keep the baseline set small
/// and review-friendly. Add more goldens only when a regression slips
/// past the existing samples.

Widget _surface({required ThemeMode mode, required Widget child}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: WdsTheme.light(),
    darkTheme: WdsTheme.dark(),
    themeMode: mode,
    home: Builder(
      builder: (context) {
        return MediaQuery(
          // Disable animations so async curves don't perturb the snapshot.
          data: MediaQuery.of(context).copyWith(disableAnimations: true),
          child: Scaffold(
            backgroundColor: Theme.of(
              context,
            ).extension<WdsColorScheme>()!.backgroundNormalNormal,
            body: Padding(padding: const EdgeInsets.all(16), child: child),
          ),
        );
      },
    ),
  );
}

Future<void> _pumpFixed(
  WidgetTester tester,
  Widget app, {
  Size size = const Size(720, 900),
  bool settle = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(app);
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    // For matrices that include indeterminate spinners which never settle,
    // pump a few discrete frames instead of awaiting quiescence.
    await tester.pump(const Duration(milliseconds: 16));
    await tester.pump(const Duration(milliseconds: 16));
  }
}

Widget _buttonMatrix() {
  Widget cell(Widget c) => Padding(padding: const EdgeInsets.all(6), child: c);

  Row row({required String label, required List<Widget> children}) => Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: 140,
        child: Text(label, style: const TextStyle(fontSize: 13)),
      ),
      ...children.map(cell),
    ],
  );

  Widget btn({
    required String text,
    required WdsButtonVariant variant,
    required WdsButtonColor color,
    required WdsButtonSize size,
    bool disabled = false,
    bool loading = false,
  }) {
    return WdsButton(
      onPressed: disabled ? null : () {},
      variant: variant,
      color: color,
      size: size,
      loading: loading,
      child: Text(text),
    );
  }

  final variants = [
    ('Solid Primary', WdsButtonVariant.solid, WdsButtonColor.primary),
    ('Solid Assistive', WdsButtonVariant.solid, WdsButtonColor.assistive),
    ('Outlined Primary', WdsButtonVariant.outlined, WdsButtonColor.primary),
    ('Outlined Assistive', WdsButtonVariant.outlined, WdsButtonColor.assistive),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final (label, variant, color) in variants)
        row(
          label: label,
          children: [
            btn(
              text: 'S',
              variant: variant,
              color: color,
              size: WdsButtonSize.small,
            ),
            btn(
              text: 'Medium',
              variant: variant,
              color: color,
              size: WdsButtonSize.medium,
            ),
            btn(
              text: 'Large action',
              variant: variant,
              color: color,
              size: WdsButtonSize.large,
            ),
            btn(
              text: 'Disabled',
              variant: variant,
              color: color,
              size: WdsButtonSize.medium,
              disabled: true,
            ),
            btn(
              text: 'Loading',
              variant: variant,
              color: color,
              size: WdsButtonSize.medium,
              loading: true,
            ),
          ],
        ),
    ],
  );
}

Widget _cardSample() {
  return SizedBox(
    width: 320,
    child: WdsCard(
      child: WdsCardContent(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: WdsCardThumbnail(
              child: Container(color: const Color(0xFF9EC5FF)),
            ),
          ),
          const WdsCardTitle('Composable card'),
          const WdsCardCaption(
            'Compose Thumbnail / Title / Caption / Content slots into rich layouts.',
          ),
        ],
      ),
    ),
  );
}

Widget _textFieldSample() {
  return const SizedBox(
    width: 320,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WdsTextField(label: 'Email', placeholder: 'name@example.com'),
        SizedBox(height: 12),
        WdsTextField(
          label: 'Password',
          placeholder: '••••••',
          helperText: '8+ characters',
        ),
        SizedBox(height: 12),
        WdsTextField(
          label: 'Username',
          placeholder: 'taken_handle',
          errorText: 'Already in use',
        ),
        SizedBox(height: 12),
        WdsTextField(
          label: 'Locked',
          placeholder: 'system value',
          disabled: true,
        ),
      ],
    ),
  );
}

Widget _modalSample() {
  return Center(
    child: SizedBox(
      width: 480,
      child: Material(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WdsModalNavigation(title: 'Confirm action'),
            const WdsModalContent(
              child: Text(
                'Are you sure you want to delete this item? This cannot be undone.',
              ),
            ),
            WdsModalActionArea(
              actions: [
                WdsButton(
                  onPressed: () {},
                  variant: WdsButtonVariant.outlined,
                  color: WdsButtonColor.assistive,
                  child: const Text('Cancel'),
                ),
                WdsButton(onPressed: () {}, child: const Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void main() {
  for (final (modeName, mode) in [
    ('light', ThemeMode.light),
    ('dark', ThemeMode.dark),
  ]) {
    testWidgets('Button matrix · $modeName', (tester) async {
      await _pumpFixed(
        tester,
        _surface(mode: mode, child: _buttonMatrix()),
        size: const Size(1000, 380),
        settle: false,
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/button_matrix_$modeName.png'),
      );
    });

    testWidgets('Card composition · $modeName', (tester) async {
      await _pumpFixed(
        tester,
        _surface(
          mode: mode,
          child: Center(child: _cardSample()),
        ),
        size: const Size(420, 460),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/card_$modeName.png'),
      );
    });

    testWidgets('TextField states · $modeName', (tester) async {
      await _pumpFixed(
        tester,
        _surface(
          mode: mode,
          child: Center(child: _textFieldSample()),
        ),
        size: const Size(420, 600),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/text_field_$modeName.png'),
      );
    });

    testWidgets('Modal popup composition · $modeName', (tester) async {
      await _pumpFixed(
        tester,
        _surface(mode: mode, child: _modalSample()),
        size: const Size(560, 360),
      );
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/modal_$modeName.png'),
      );
    });
  }
}
