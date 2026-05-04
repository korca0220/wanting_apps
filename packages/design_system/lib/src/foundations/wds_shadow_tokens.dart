import 'package:flutter/painting.dart';

import 'wds_colors.dart';

/// Elevation tokens — 5 levels of `shadow/normal/*`.
///
/// CSS source from `docs/foundations/00-shadow.md` translated to Flutter
/// `BoxShadow` lists. CSS `0px Y blur -spread` maps to
/// `BoxShadow(offset: Offset(0, Y), blurRadius: blur, spreadRadius: -spread)`.
/// Mode-invariant per spec.
class WdsShadowTokens {
  const WdsShadowTokens._();

  static Color _base(double a) => WdsColors.neutralShadowBase.withValues(alpha: a);

  static final List<BoxShadow> normalXSmall = [
    BoxShadow(
      color: _base(0.10),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: -1,
    ),
  ];

  static final List<BoxShadow> normalSmall = [
    BoxShadow(
      color: _base(0.06),
      offset: const Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: _base(0.06),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
  ];

  static final List<BoxShadow> normalMedium = [
    BoxShadow(
      color: _base(0.07),
      offset: const Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
    BoxShadow(
      color: _base(0.07),
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
  ];

  static final List<BoxShadow> normalLarge = [
    BoxShadow(
      color: _base(0.08),
      offset: const Offset(0, 6),
      blurRadius: 10,
      spreadRadius: -4,
    ),
    BoxShadow(
      color: _base(0.08),
      offset: const Offset(0, 16),
      blurRadius: 24,
      spreadRadius: -6,
    ),
  ];

  static final List<BoxShadow> normalXLarge = [
    BoxShadow(
      color: _base(0.10),
      offset: const Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -5,
    ),
    BoxShadow(
      color: _base(0.12),
      offset: const Offset(0, 24),
      blurRadius: 38,
      spreadRadius: -10,
    ),
  ];

  // Spread-style shadows (single shadow, large blur).
  static final List<BoxShadow> spreadSmall = [
    BoxShadow(
      color: _base(0.10),
      offset: Offset.zero,
      blurRadius: 60,
    ),
  ];

  static final List<BoxShadow> spreadMedium = [
    BoxShadow(
      color: _base(0.16),
      offset: const Offset(0, 15),
      blurRadius: 75,
    ),
  ];
}
