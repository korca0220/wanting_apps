import 'package:flutter/material.dart';

import '../foundations/wds_shadow_tokens.dart';

/// Elevation aliases as `ThemeExtension`. Mode-invariant per docs.
@immutable
class WdsShadowsTheme extends ThemeExtension<WdsShadowsTheme> {
  const WdsShadowsTheme({
    required this.normalXSmall,
    required this.normalSmall,
    required this.normalMedium,
    required this.normalLarge,
    required this.normalXLarge,
    required this.spreadSmall,
    required this.spreadMedium,
  });

  final List<BoxShadow> normalXSmall;
  final List<BoxShadow> normalSmall;
  final List<BoxShadow> normalMedium;
  final List<BoxShadow> normalLarge;
  final List<BoxShadow> normalXLarge;
  final List<BoxShadow> spreadSmall;
  final List<BoxShadow> spreadMedium;

  factory WdsShadowsTheme.standard() => WdsShadowsTheme(
    normalXSmall: WdsShadowTokens.normalXSmall,
    normalSmall: WdsShadowTokens.normalSmall,
    normalMedium: WdsShadowTokens.normalMedium,
    normalLarge: WdsShadowTokens.normalLarge,
    normalXLarge: WdsShadowTokens.normalXLarge,
    spreadSmall: WdsShadowTokens.spreadSmall,
    spreadMedium: WdsShadowTokens.spreadMedium,
  );

  @override
  WdsShadowsTheme copyWith({
    List<BoxShadow>? normalXSmall,
    List<BoxShadow>? normalSmall,
    List<BoxShadow>? normalMedium,
    List<BoxShadow>? normalLarge,
    List<BoxShadow>? normalXLarge,
    List<BoxShadow>? spreadSmall,
    List<BoxShadow>? spreadMedium,
  }) {
    return WdsShadowsTheme(
      normalXSmall: normalXSmall ?? this.normalXSmall,
      normalSmall: normalSmall ?? this.normalSmall,
      normalMedium: normalMedium ?? this.normalMedium,
      normalLarge: normalLarge ?? this.normalLarge,
      normalXLarge: normalXLarge ?? this.normalXLarge,
      spreadSmall: spreadSmall ?? this.spreadSmall,
      spreadMedium: spreadMedium ?? this.spreadMedium,
    );
  }

  @override
  WdsShadowsTheme lerp(ThemeExtension<WdsShadowsTheme>? other, double t) {
    if (other is! WdsShadowsTheme) return this;
    // BoxShadow lists don't support per-element lerp without aligned
    // counts. Snap to `t < 0.5` ? this : other.
    return t < 0.5 ? this : other;
  }
}
