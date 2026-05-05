import 'package:flutter/material.dart';

import 'wds_color_scheme.dart';
import 'wds_motion_theme.dart';
import 'wds_radius_theme.dart';
import 'wds_shadow_theme.dart';
import 'wds_spacing_theme.dart';
import 'wds_typography.dart';

/// `BuildContext` accessors for design-system tokens.
///
/// Each getter pulls the matching `ThemeExtension` from the ambient theme.
/// Throws if `MaterialApp.theme` was not built via `WdsTheme.light/.dark`.
extension WdsThemeAccess on BuildContext {
  WdsColorScheme get wdsColors => Theme.of(this).extension<WdsColorScheme>()!;

  WdsTypography get wdsType => Theme.of(this).extension<WdsTypography>()!;

  WdsSpacingTheme get wdsSpacing =>
      Theme.of(this).extension<WdsSpacingTheme>()!;

  WdsRadiusTheme get wdsRadius => Theme.of(this).extension<WdsRadiusTheme>()!;

  WdsShadowsTheme get wdsShadows =>
      Theme.of(this).extension<WdsShadowsTheme>()!;

  WdsMotionTheme get wdsMotion => Theme.of(this).extension<WdsMotionTheme>()!;
}
