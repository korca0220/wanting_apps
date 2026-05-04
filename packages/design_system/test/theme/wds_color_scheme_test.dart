import 'package:design_system/design_system.dart';
import 'package:design_system/src/foundations/wds_colors.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WdsColorScheme.light()', () {
    final s = WdsColorScheme.light();

    test('primary mapping', () {
      expect(s.primaryNormal, WdsColors.blue50);
      expect(s.primaryStrong, WdsColors.blue45);
      expect(s.primaryHeavy, WdsColors.blue40);
      expect(s.primarySubtle, WdsColors.blue95);
    });

    test('on-primary is white in light mode', () {
      expect(s.onPrimary, WdsColors.common100);
    });

    test('label normal/strong', () {
      expect(s.labelNormal, WdsColors.coolNeutral10);
      expect(s.labelStrong, WdsColors.common0);
    });
  });

  group('WdsColorScheme.dark()', () {
    final s = WdsColorScheme.dark();

    test('primary mapping shifts to blue/60s', () {
      expect(s.primaryNormal, WdsColors.blue60);
      expect(s.primaryStrong, WdsColors.blue55);
      expect(s.primaryHeavy, WdsColors.blue50);
      expect(s.primarySubtle, WdsColors.blue20);
    });

    test('on-primary is near-black in dark mode (AA fix)', () {
      // Decision: docs/foundations/00-color.md adds color/onPrimary so the
      // dark-mode primary button can hit AA contrast.
      expect(s.onPrimary, WdsColors.coolNeutral10);
    });
  });
}
