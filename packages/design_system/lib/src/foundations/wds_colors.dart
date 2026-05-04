import 'package:flutter/painting.dart';

/// Primitive color palette — atomic, mode-invariant.
///
/// Components should not reference these directly. Use the semantic
/// [WdsColorScheme] via `Theme.of(context).extension<WdsColorScheme>()`
/// or the `context.wdsColors` helper.
///
/// Source: `packages/design_system/docs/foundations/00-color.md`.
class WdsColors {
  const WdsColors._();

  // Common
  static const Color common0 = Color(0xFF000000);
  static const Color common100 = Color(0xFFFFFFFF);

  // Brand — Blue (50 = brand key)
  static const Color blue10 = Color(0xFF001536);
  static const Color blue20 = Color(0xFF002966);
  static const Color blue30 = Color(0xFF003E9C);
  static const Color blue40 = Color(0xFF0054D1);
  static const Color blue45 = Color(0xFF005EEB);
  static const Color blue50 = Color(0xFF0066FF);
  static const Color blue55 = Color(0xFF1A75FF);
  static const Color blue60 = Color(0xFF3385FF);
  static const Color blue65 = Color(0xFF4F95FF);
  static const Color blue70 = Color(0xFF69A5FF);
  static const Color blue80 = Color(0xFF9EC5FF);
  static const Color blue90 = Color(0xFFC9DEFE);
  static const Color blue95 = Color(0xFFEAF2FE);
  static const Color blue99 = Color(0xFFF7FBFF);

  // Cool Neutral (text / surface base)
  static const Color coolNeutral5 = Color(0xFF0F0F10);
  static const Color coolNeutral7 = Color(0xFF141415);
  static const Color coolNeutral10 = Color(0xFF171719);
  static const Color coolNeutral15 = Color(0xFF1B1C1E);
  static const Color coolNeutral17 = Color(0xFF212225);
  static const Color coolNeutral20 = Color(0xFF292A2D);
  static const Color coolNeutral22 = Color(0xFF2E2F33);
  static const Color coolNeutral23 = Color(0xFF333438);
  static const Color coolNeutral25 = Color(0xFF37383C);
  static const Color coolNeutral30 = Color(0xFF46474C);
  static const Color coolNeutral40 = Color(0xFF5A5C63);
  static const Color coolNeutral50 = Color(0xFF70737C);
  static const Color coolNeutral60 = Color(0xFF878A93);
  static const Color coolNeutral70 = Color(0xFF989BA2);
  static const Color coolNeutral80 = Color(0xFFAEB0B6);
  static const Color coolNeutral90 = Color(0xFFC2C4C8);
  static const Color coolNeutral95 = Color(0xFFDBDCDF);
  static const Color coolNeutral96 = Color(0xFFE1E2E4);
  static const Color coolNeutral97 = Color(0xFFEAEBEC);
  static const Color coolNeutral98 = Color(0xFFF4F4F5);
  static const Color coolNeutral99 = Color(0xFFF7F7F8);

  // Status — /50 are spec-verified; /60 are interpolated by HSL +10%
  // lightness (standard ramp pattern matching the blue family). Source
  // wds-theme atomic packages are not vendored into this repo, so /60
  // values are marked "Inferred" pending designer review — see
  // docs/foundations/00-color.md and quality_report.md.
  static const Color red50 = Color(0xFFFF4242);
  static const Color red60 = Color(0xFFFF6B6B);
  static const Color green50 = Color(0xFF00BF40);
  static const Color green60 = Color(0xFF2CD460);
  static const Color orange50 = Color(0xFFFF9200);
  static const Color orange60 = Color(0xFFFFA833);

  // Accent — minimal palette covering Spinner 4-color cycle and Badge
  // accent. Not the full 11-hue spec; track in quality_report.md.
  static const Color cyan50 = Color(0xFF00B8D9);
  static const Color violet50 = Color(0xFF7B5BFF);
  static const Color pink50 = Color(0xFFFF4D8A);
  static const Color lime50 = Color(0xFF7BCB1A);

  // Shadow base — 'neutral.10' from wds (dark warm gray, distinct from
  // coolNeutral). Used as the base for all elevation shadows with alpha.
  static const Color neutralShadowBase = Color(0xFF171717);
}
