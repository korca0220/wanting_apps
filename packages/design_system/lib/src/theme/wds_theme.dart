import 'package:flutter/material.dart';

import 'wds_color_scheme.dart';
import 'wds_motion_theme.dart';
import 'wds_radius_theme.dart';
import 'wds_shadow_theme.dart';
import 'wds_spacing_theme.dart';
import 'wds_typography.dart';

/// Top-level theme factory.
///
/// Use `MaterialApp(theme: WdsTheme.light(), darkTheme: WdsTheme.dark())`
/// then access tokens via `context.wdsColors`, `context.wdsType`, etc.
class WdsTheme {
  const WdsTheme._();

  static ThemeData light() => _build(
        brightness: Brightness.light,
        colors: WdsColorScheme.light(),
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        colors: WdsColorScheme.dark(),
      );

  static ThemeData _build({
    required Brightness brightness,
    required WdsColorScheme colors,
  }) {
    final typography = WdsTypography.from(labelColor: colors.labelNormal);
    final spacing = WdsSpacingTheme.standard();
    final radius = WdsRadiusTheme.standard();
    final shadows = WdsShadowsTheme.standard();
    final motion = WdsMotionTheme.standard();

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: colors.primaryNormal,
      onPrimary: colors.onPrimary,
      primaryContainer: colors.primarySubtle,
      onPrimaryContainer: colors.primaryHeavy,
      secondary: colors.inversePrimary,
      onSecondary: colors.staticWhite,
      surface: colors.backgroundNormalNormal,
      onSurface: colors.labelNormal,
      surfaceContainerHighest: colors.backgroundElevatedNormal,
      surfaceContainerHigh: colors.backgroundElevatedAlternative,
      onSurfaceVariant: colors.labelNeutral,
      error: colors.statusNegative,
      onError: colors.staticWhite,
      outline: colors.lineNormalNormal,
      outlineVariant: colors.lineNormalNeutral,
      inverseSurface: colors.inverseBackground,
      onInverseSurface: colors.inverseLabel,
      inversePrimary: colors.inversePrimary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.backgroundNormalNormal,
      textTheme: TextTheme(
        displayLarge: typography.display1,
        displayMedium: typography.display2,
        displaySmall: typography.display3,
        headlineLarge: typography.title1,
        headlineMedium: typography.title2,
        headlineSmall: typography.title3,
        titleLarge: typography.heading1,
        titleMedium: typography.heading2,
        titleSmall: typography.headline2,
        bodyLarge: typography.body1,
        bodyMedium: typography.body2,
        bodySmall: typography.caption1,
        labelLarge: typography.label1,
        labelMedium: typography.label2,
        labelSmall: typography.caption2,
      ),
      extensions: <ThemeExtension<dynamic>>[
        colors,
        typography,
        spacing,
        radius,
        shadows,
        motion,
      ],
    );
  }
}
