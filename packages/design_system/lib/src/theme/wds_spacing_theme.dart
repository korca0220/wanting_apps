import 'package:flutter/material.dart';

import '../foundations/wds_spacing.dart';

/// Semantic spacing aliases. Components prefer these over raw primitives.
@immutable
class WdsSpacingTheme extends ThemeExtension<WdsSpacingTheme> {
  const WdsSpacingTheme({
    required this.componentXs,
    required this.componentSm,
    required this.componentMd,
    required this.componentLg,
    required this.componentXl,
    required this.layoutSm,
    required this.layoutMd,
    required this.layoutLg,
    required this.layoutXl,
  });

  final double componentXs;
  final double componentSm;
  final double componentMd;
  final double componentLg;
  final double componentXl;
  final double layoutSm;
  final double layoutMd;
  final double layoutLg;
  final double layoutXl;

  factory WdsSpacingTheme.standard() => const WdsSpacingTheme(
        componentXs: WdsSpacing.s4,
        componentSm: WdsSpacing.s8,
        componentMd: WdsSpacing.s12,
        componentLg: WdsSpacing.s16,
        componentXl: WdsSpacing.s24,
        layoutSm: WdsSpacing.s32,
        layoutMd: WdsSpacing.s48,
        layoutLg: WdsSpacing.s64,
        layoutXl: WdsSpacing.s80,
      );

  @override
  WdsSpacingTheme copyWith({
    double? componentXs,
    double? componentSm,
    double? componentMd,
    double? componentLg,
    double? componentXl,
    double? layoutSm,
    double? layoutMd,
    double? layoutLg,
    double? layoutXl,
  }) {
    return WdsSpacingTheme(
      componentXs: componentXs ?? this.componentXs,
      componentSm: componentSm ?? this.componentSm,
      componentMd: componentMd ?? this.componentMd,
      componentLg: componentLg ?? this.componentLg,
      componentXl: componentXl ?? this.componentXl,
      layoutSm: layoutSm ?? this.layoutSm,
      layoutMd: layoutMd ?? this.layoutMd,
      layoutLg: layoutLg ?? this.layoutLg,
      layoutXl: layoutXl ?? this.layoutXl,
    );
  }

  @override
  WdsSpacingTheme lerp(ThemeExtension<WdsSpacingTheme>? other, double t) {
    if (other is! WdsSpacingTheme) return this;
    double l(double a, double b) => a + (b - a) * t;
    return WdsSpacingTheme(
      componentXs: l(componentXs, other.componentXs),
      componentSm: l(componentSm, other.componentSm),
      componentMd: l(componentMd, other.componentMd),
      componentLg: l(componentLg, other.componentLg),
      componentXl: l(componentXl, other.componentXl),
      layoutSm: l(layoutSm, other.layoutSm),
      layoutMd: l(layoutMd, other.layoutMd),
      layoutLg: l(layoutLg, other.layoutLg),
      layoutXl: l(layoutXl, other.layoutXl),
    );
  }
}
