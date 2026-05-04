import 'package:design_system/src/foundations/wds_colors.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

int argb(Color c) =>
    ((c.a * 255).round() << 24) |
    ((c.r * 255).round() << 16) |
    ((c.g * 255).round() << 8) |
    (c.b * 255).round();

void main() {
  group('WdsColors primitives — spec lock-in', () {
    test('common', () {
      expect(argb(WdsColors.common0), 0xFF000000);
      expect(argb(WdsColors.common100), 0xFFFFFFFF);
    });

    test('blue brand stops', () {
      expect(argb(WdsColors.blue50), 0xFF0066FF);
      expect(argb(WdsColors.blue60), 0xFF3385FF);
      expect(argb(WdsColors.blue45), 0xFF005EEB);
      expect(argb(WdsColors.blue40), 0xFF0054D1);
      expect(argb(WdsColors.blue95), 0xFFEAF2FE);
    });

    test('coolNeutral key stops', () {
      expect(argb(WdsColors.coolNeutral10), 0xFF171719);
      expect(argb(WdsColors.coolNeutral15), 0xFF1B1C1E);
      expect(argb(WdsColors.coolNeutral99), 0xFFF7F7F8);
    });

    test('status keys', () {
      expect(argb(WdsColors.red50), 0xFFFF4242);
      expect(argb(WdsColors.green50), 0xFF00BF40);
      expect(argb(WdsColors.orange50), 0xFFFF9200);
    });
  });
}
