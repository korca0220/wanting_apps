import 'package:flutter/material.dart';

import '../foundations/wds_colors.dart';

/// Semantic color scheme — what components actually reference.
///
/// Components don't see brightness; they read tokens like
/// `context.wdsColors.primaryNormal`. The `.light()` / `.dark()` factories
/// pick the appropriate primitive per mode.
///
/// Source: `packages/design_system/docs/foundations/00-color.md`.
@immutable
class WdsColorScheme extends ThemeExtension<WdsColorScheme> {
  const WdsColorScheme({
    // Primary
    required this.primaryNormal,
    required this.primaryStrong,
    required this.primaryHeavy,
    required this.primarySubtle,
    // On-primary (added in this lib to fix dark-mode AA contrast — see
    // docs/foundations/00-color.md)
    required this.onPrimary,
    // Label
    required this.labelNormal,
    required this.labelStrong,
    required this.labelNeutral,
    required this.labelAlternative,
    required this.labelAssistive,
    required this.labelDisable,
    // Background
    required this.backgroundNormalNormal,
    required this.backgroundNormalAlternative,
    required this.backgroundElevatedNormal,
    required this.backgroundElevatedAlternative,
    required this.backgroundTransparentNormal,
    required this.backgroundTransparentAlternative,
    // Interaction
    required this.interactionInactive,
    required this.interactionDisable,
    // Line
    required this.lineNormalNormal,
    required this.lineNormalNeutral,
    required this.lineNormalAlternative,
    required this.lineSolidNormal,
    required this.lineSolidNeutral,
    required this.lineSolidAlternative,
    // Status
    required this.statusPositive,
    required this.statusCautionary,
    required this.statusNegative,
    // Fill
    required this.fillNormal,
    required this.fillStrong,
    required this.fillAlternative,
    // Inverse
    required this.inversePrimary,
    required this.inverseBackground,
    required this.inverseLabel,
    // Material (backdrop)
    required this.materialDimmer,
    // Static (mode-invariant convenience)
    required this.staticWhite,
    required this.staticBlack,
  });

  final Color primaryNormal;
  final Color primaryStrong;
  final Color primaryHeavy;
  final Color primarySubtle;

  /// Foreground color for use ON [primaryNormal] surfaces. Light mode is
  /// white; dark mode falls back to a near-black to preserve AA contrast
  /// against `blue/60`. Added by this Flutter port — see
  /// `docs/foundations/00-color.md` "On-Primary" section.
  final Color onPrimary;

  final Color labelNormal;
  final Color labelStrong;
  final Color labelNeutral;
  final Color labelAlternative;
  final Color labelAssistive;
  final Color labelDisable;

  final Color backgroundNormalNormal;
  final Color backgroundNormalAlternative;
  final Color backgroundElevatedNormal;
  final Color backgroundElevatedAlternative;
  final Color backgroundTransparentNormal;
  final Color backgroundTransparentAlternative;

  final Color interactionInactive;
  final Color interactionDisable;

  final Color lineNormalNormal;
  final Color lineNormalNeutral;
  final Color lineNormalAlternative;
  final Color lineSolidNormal;
  final Color lineSolidNeutral;
  final Color lineSolidAlternative;

  final Color statusPositive;
  final Color statusCautionary;
  final Color statusNegative;

  final Color fillNormal;
  final Color fillStrong;
  final Color fillAlternative;

  final Color inversePrimary;
  final Color inverseBackground;
  final Color inverseLabel;

  final Color materialDimmer;

  final Color staticWhite;
  final Color staticBlack;

  factory WdsColorScheme.light() {
    Color withA(Color c, double a) => c.withValues(alpha: a);
    return WdsColorScheme(
      primaryNormal: WdsColors.blue50,
      primaryStrong: WdsColors.blue45,
      primaryHeavy: WdsColors.blue40,
      primarySubtle: WdsColors.blue95,
      onPrimary: WdsColors.common100,
      labelNormal: WdsColors.coolNeutral10,
      labelStrong: WdsColors.common0,
      labelNeutral: withA(WdsColors.coolNeutral22, 0.88),
      labelAlternative: withA(WdsColors.coolNeutral25, 0.61),
      labelAssistive: withA(WdsColors.coolNeutral25, 0.28),
      labelDisable: withA(WdsColors.coolNeutral25, 0.16),
      backgroundNormalNormal: WdsColors.common100,
      backgroundNormalAlternative: WdsColors.coolNeutral99,
      backgroundElevatedNormal: WdsColors.common100,
      backgroundElevatedAlternative: WdsColors.coolNeutral99,
      backgroundTransparentNormal: withA(WdsColors.common100, 0.08),
      backgroundTransparentAlternative: withA(WdsColors.common100, 0.28),
      interactionInactive: WdsColors.coolNeutral70,
      interactionDisable: WdsColors.coolNeutral98,
      lineNormalNormal: withA(WdsColors.coolNeutral50, 0.22),
      lineNormalNeutral: withA(WdsColors.coolNeutral50, 0.16),
      lineNormalAlternative: withA(WdsColors.coolNeutral50, 0.08),
      lineSolidNormal: WdsColors.coolNeutral96,
      lineSolidNeutral: WdsColors.coolNeutral97,
      lineSolidAlternative: WdsColors.coolNeutral98,
      statusPositive: WdsColors.green50,
      statusCautionary: WdsColors.orange50,
      statusNegative: WdsColors.red50,
      fillNormal: withA(WdsColors.coolNeutral50, 0.08),
      fillStrong: withA(WdsColors.coolNeutral50, 0.16),
      fillAlternative: withA(WdsColors.coolNeutral50, 0.05),
      inversePrimary: WdsColors.blue60,
      inverseBackground: WdsColors.coolNeutral15,
      inverseLabel: WdsColors.coolNeutral99,
      materialDimmer: withA(WdsColors.coolNeutral10, 0.52),
      staticWhite: WdsColors.common100,
      staticBlack: WdsColors.common0,
    );
  }

  factory WdsColorScheme.dark() {
    Color withA(Color c, double a) => c.withValues(alpha: a);
    return WdsColorScheme(
      primaryNormal: WdsColors.blue60,
      primaryStrong: WdsColors.blue55,
      primaryHeavy: WdsColors.blue50,
      primarySubtle: WdsColors.blue20,
      // Decision: dark on-primary is near-black to satisfy AA against blue/60
      onPrimary: WdsColors.coolNeutral10,
      labelNormal: WdsColors.coolNeutral99,
      labelStrong: WdsColors.common100,
      labelNeutral: withA(WdsColors.coolNeutral90, 0.88),
      labelAlternative: withA(WdsColors.coolNeutral80, 0.61),
      labelAssistive: withA(WdsColors.coolNeutral80, 0.28),
      labelDisable: withA(WdsColors.coolNeutral70, 0.16),
      backgroundNormalNormal: WdsColors.coolNeutral15,
      backgroundNormalAlternative: WdsColors.coolNeutral5,
      backgroundElevatedNormal: WdsColors.coolNeutral17,
      backgroundElevatedAlternative: WdsColors.coolNeutral7,
      backgroundTransparentNormal: withA(WdsColors.coolNeutral17, 0.61),
      backgroundTransparentAlternative: withA(WdsColors.coolNeutral17, 0.61),
      interactionInactive: WdsColors.coolNeutral40,
      interactionDisable: WdsColors.coolNeutral22,
      lineNormalNormal: withA(WdsColors.coolNeutral50, 0.32),
      lineNormalNeutral: withA(WdsColors.coolNeutral50, 0.28),
      lineNormalAlternative: withA(WdsColors.coolNeutral50, 0.22),
      lineSolidNormal: WdsColors.coolNeutral25,
      lineSolidNeutral: WdsColors.coolNeutral23,
      lineSolidAlternative: WdsColors.coolNeutral22,
      // TODO(status-dark): docs reference green/60, orange/60, red/60 for
      // dark mode. Hex values not yet inlined into 00-color.md, so we fall
      // back to the /50 stop here. Track in quality_report.md.
      statusPositive: WdsColors.green50,
      statusCautionary: WdsColors.orange50,
      statusNegative: WdsColors.red50,
      fillNormal: withA(WdsColors.coolNeutral50, 0.22),
      fillStrong: withA(WdsColors.coolNeutral50, 0.28),
      fillAlternative: withA(WdsColors.coolNeutral50, 0.12),
      inversePrimary: WdsColors.blue50,
      inverseBackground: WdsColors.common100,
      inverseLabel: WdsColors.coolNeutral10,
      materialDimmer: withA(WdsColors.coolNeutral10, 0.74),
      staticWhite: WdsColors.common100,
      staticBlack: WdsColors.common0,
    );
  }

  @override
  WdsColorScheme copyWith({
    Color? primaryNormal,
    Color? primaryStrong,
    Color? primaryHeavy,
    Color? primarySubtle,
    Color? onPrimary,
    Color? labelNormal,
    Color? labelStrong,
    Color? labelNeutral,
    Color? labelAlternative,
    Color? labelAssistive,
    Color? labelDisable,
    Color? backgroundNormalNormal,
    Color? backgroundNormalAlternative,
    Color? backgroundElevatedNormal,
    Color? backgroundElevatedAlternative,
    Color? backgroundTransparentNormal,
    Color? backgroundTransparentAlternative,
    Color? interactionInactive,
    Color? interactionDisable,
    Color? lineNormalNormal,
    Color? lineNormalNeutral,
    Color? lineNormalAlternative,
    Color? lineSolidNormal,
    Color? lineSolidNeutral,
    Color? lineSolidAlternative,
    Color? statusPositive,
    Color? statusCautionary,
    Color? statusNegative,
    Color? fillNormal,
    Color? fillStrong,
    Color? fillAlternative,
    Color? inversePrimary,
    Color? inverseBackground,
    Color? inverseLabel,
    Color? materialDimmer,
    Color? staticWhite,
    Color? staticBlack,
  }) {
    return WdsColorScheme(
      primaryNormal: primaryNormal ?? this.primaryNormal,
      primaryStrong: primaryStrong ?? this.primaryStrong,
      primaryHeavy: primaryHeavy ?? this.primaryHeavy,
      primarySubtle: primarySubtle ?? this.primarySubtle,
      onPrimary: onPrimary ?? this.onPrimary,
      labelNormal: labelNormal ?? this.labelNormal,
      labelStrong: labelStrong ?? this.labelStrong,
      labelNeutral: labelNeutral ?? this.labelNeutral,
      labelAlternative: labelAlternative ?? this.labelAlternative,
      labelAssistive: labelAssistive ?? this.labelAssistive,
      labelDisable: labelDisable ?? this.labelDisable,
      backgroundNormalNormal:
          backgroundNormalNormal ?? this.backgroundNormalNormal,
      backgroundNormalAlternative:
          backgroundNormalAlternative ?? this.backgroundNormalAlternative,
      backgroundElevatedNormal:
          backgroundElevatedNormal ?? this.backgroundElevatedNormal,
      backgroundElevatedAlternative:
          backgroundElevatedAlternative ?? this.backgroundElevatedAlternative,
      backgroundTransparentNormal:
          backgroundTransparentNormal ?? this.backgroundTransparentNormal,
      backgroundTransparentAlternative: backgroundTransparentAlternative ??
          this.backgroundTransparentAlternative,
      interactionInactive: interactionInactive ?? this.interactionInactive,
      interactionDisable: interactionDisable ?? this.interactionDisable,
      lineNormalNormal: lineNormalNormal ?? this.lineNormalNormal,
      lineNormalNeutral: lineNormalNeutral ?? this.lineNormalNeutral,
      lineNormalAlternative:
          lineNormalAlternative ?? this.lineNormalAlternative,
      lineSolidNormal: lineSolidNormal ?? this.lineSolidNormal,
      lineSolidNeutral: lineSolidNeutral ?? this.lineSolidNeutral,
      lineSolidAlternative: lineSolidAlternative ?? this.lineSolidAlternative,
      statusPositive: statusPositive ?? this.statusPositive,
      statusCautionary: statusCautionary ?? this.statusCautionary,
      statusNegative: statusNegative ?? this.statusNegative,
      fillNormal: fillNormal ?? this.fillNormal,
      fillStrong: fillStrong ?? this.fillStrong,
      fillAlternative: fillAlternative ?? this.fillAlternative,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      inverseBackground: inverseBackground ?? this.inverseBackground,
      inverseLabel: inverseLabel ?? this.inverseLabel,
      materialDimmer: materialDimmer ?? this.materialDimmer,
      staticWhite: staticWhite ?? this.staticWhite,
      staticBlack: staticBlack ?? this.staticBlack,
    );
  }

  @override
  WdsColorScheme lerp(ThemeExtension<WdsColorScheme>? other, double t) {
    if (other is! WdsColorScheme) return this;
    Color lerpC(Color a, Color b) => Color.lerp(a, b, t)!;
    return WdsColorScheme(
      primaryNormal: lerpC(primaryNormal, other.primaryNormal),
      primaryStrong: lerpC(primaryStrong, other.primaryStrong),
      primaryHeavy: lerpC(primaryHeavy, other.primaryHeavy),
      primarySubtle: lerpC(primarySubtle, other.primarySubtle),
      onPrimary: lerpC(onPrimary, other.onPrimary),
      labelNormal: lerpC(labelNormal, other.labelNormal),
      labelStrong: lerpC(labelStrong, other.labelStrong),
      labelNeutral: lerpC(labelNeutral, other.labelNeutral),
      labelAlternative: lerpC(labelAlternative, other.labelAlternative),
      labelAssistive: lerpC(labelAssistive, other.labelAssistive),
      labelDisable: lerpC(labelDisable, other.labelDisable),
      backgroundNormalNormal:
          lerpC(backgroundNormalNormal, other.backgroundNormalNormal),
      backgroundNormalAlternative: lerpC(
          backgroundNormalAlternative, other.backgroundNormalAlternative),
      backgroundElevatedNormal:
          lerpC(backgroundElevatedNormal, other.backgroundElevatedNormal),
      backgroundElevatedAlternative: lerpC(
          backgroundElevatedAlternative, other.backgroundElevatedAlternative),
      backgroundTransparentNormal: lerpC(
          backgroundTransparentNormal, other.backgroundTransparentNormal),
      backgroundTransparentAlternative: lerpC(
          backgroundTransparentAlternative,
          other.backgroundTransparentAlternative),
      interactionInactive: lerpC(interactionInactive, other.interactionInactive),
      interactionDisable: lerpC(interactionDisable, other.interactionDisable),
      lineNormalNormal: lerpC(lineNormalNormal, other.lineNormalNormal),
      lineNormalNeutral: lerpC(lineNormalNeutral, other.lineNormalNeutral),
      lineNormalAlternative:
          lerpC(lineNormalAlternative, other.lineNormalAlternative),
      lineSolidNormal: lerpC(lineSolidNormal, other.lineSolidNormal),
      lineSolidNeutral: lerpC(lineSolidNeutral, other.lineSolidNeutral),
      lineSolidAlternative:
          lerpC(lineSolidAlternative, other.lineSolidAlternative),
      statusPositive: lerpC(statusPositive, other.statusPositive),
      statusCautionary: lerpC(statusCautionary, other.statusCautionary),
      statusNegative: lerpC(statusNegative, other.statusNegative),
      fillNormal: lerpC(fillNormal, other.fillNormal),
      fillStrong: lerpC(fillStrong, other.fillStrong),
      fillAlternative: lerpC(fillAlternative, other.fillAlternative),
      inversePrimary: lerpC(inversePrimary, other.inversePrimary),
      inverseBackground: lerpC(inverseBackground, other.inverseBackground),
      inverseLabel: lerpC(inverseLabel, other.inverseLabel),
      materialDimmer: lerpC(materialDimmer, other.materialDimmer),
      staticWhite: lerpC(staticWhite, other.staticWhite),
      staticBlack: lerpC(staticBlack, other.staticBlack),
    );
  }
}
