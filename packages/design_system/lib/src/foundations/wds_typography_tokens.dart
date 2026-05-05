import 'package:flutter/painting.dart';

/// Typography variants from `docs/foundations/00-typography.md`.
///
/// `TextStyle` constants are color-less (color is applied at usage site or
/// baked-in via `WdsTypography` ThemeExtension). Sizes are in logical
/// pixels (1rem = 16px). `letter-spacing` em values are converted to
/// fractions of font-size at the call site if needed; here we encode them
/// as `letterSpacing` in logical pixels (em × fontSize).
class WdsTypographyTokens {
  const WdsTypographyTokens._();

  // Default weight is regular (400). Bold/medium variants are produced
  // via `.copyWith(fontWeight: ...)` at usage time. See "Bold 자동화 규칙"
  // in 00-typography.md: display/title use w700, others use w600.

  /// Bundled font family. The `design_system` package declares Pretendard
  /// in its pubspec, so any app that depends on this package picks it up
  /// automatically without further configuration.
  static const String fontFamily = 'Pretendard';

  static TextStyle _v({
    required double size,
    required double height,
    required double letterEm,
    FontWeight weight = FontWeight.w400,
  }) =>
      TextStyle(
        fontSize: size,
        height: height / size,
        letterSpacing: letterEm * size,
        fontWeight: weight,
        fontFamily: fontFamily,
      );

  static final TextStyle display1 =
      _v(size: 56, height: 72, letterEm: -0.0319);
  static final TextStyle display2 =
      _v(size: 40, height: 52, letterEm: -0.0282);
  static final TextStyle display3 =
      _v(size: 36, height: 48, letterEm: -0.027);

  static final TextStyle title1 = _v(size: 32, height: 44, letterEm: -0.0253);
  static final TextStyle title2 = _v(size: 28, height: 38, letterEm: -0.0236);
  static final TextStyle title3 = _v(size: 24, height: 32, letterEm: -0.023);

  static final TextStyle heading1 = _v(size: 22, height: 30, letterEm: -0.0194);
  static final TextStyle heading2 = _v(size: 20, height: 28, letterEm: -0.012);

  static final TextStyle headline1 =
      _v(size: 18, height: 26, letterEm: -0.002);
  static final TextStyle headline2 = _v(size: 17, height: 24, letterEm: 0);

  static final TextStyle body1 = _v(size: 16, height: 24, letterEm: 0.0057);
  static final TextStyle body1Reading =
      _v(size: 16, height: 26, letterEm: 0.0057);
  static final TextStyle body2 = _v(size: 15, height: 22, letterEm: 0.0096);
  static final TextStyle body2Reading =
      _v(size: 15, height: 24, letterEm: 0.0096);

  static final TextStyle label1 = _v(size: 14, height: 20, letterEm: 0.0145);
  static final TextStyle label1Reading =
      _v(size: 14, height: 22, letterEm: 0.0145);
  static final TextStyle label2 = _v(size: 13, height: 18, letterEm: 0.0194);

  static final TextStyle caption1 = _v(size: 12, height: 16, letterEm: 0.0252);
  static final TextStyle caption2 = _v(size: 11, height: 14, letterEm: 0.0311);
}

/// Weight tokens.
class WdsFontWeights {
  const WdsFontWeights._();

  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;

  /// `font/weight/bold` for display/title variants (w700).
  static const FontWeight boldDisplay = FontWeight.w700;

  /// `font/weight/bold` for non-display variants (w600).
  static const FontWeight bold = FontWeight.w600;
}
