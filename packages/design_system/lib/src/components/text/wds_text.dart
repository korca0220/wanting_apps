import 'package:flutter/widgets.dart';

import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_theme_ext.dart';

/// Typography scale — mirrors the variants in
/// `docs/foundations/00-typography.md` and `WdsTypographyTokens`.
enum WdsTextStyle {
  display1,
  display2,
  display3,
  title1,
  title2,
  title3,
  heading1,
  heading2,
  headline1,
  headline2,
  body1,
  body1Reading,
  body2,
  body2Reading,
  label1,
  label1Reading,
  label2,
  caption1,
  caption2,
}

/// Semantic foreground role. Resolves against `WdsColorScheme` so the same
/// call renders correctly in light/dark.
enum WdsTextColor {
  normal,
  strong,
  neutral,
  alternative,
  assistive,
  disable,
  primary,
  onPrimary,
}

/// Themed text widget — picks a typography scale + semantic color from the
/// design system. Use this instead of `Text` whenever the value is part of
/// the product surface; reach for raw `Text` only inside other DS
/// components that already own their text styling.
class WdsText extends StatelessWidget {
  const WdsText(
    this.data, {
    super.key,
    this.style = WdsTextStyle.body1,
    this.color = WdsTextColor.normal,
    this.bold = false,
    this.colorOverride,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.softWrap,
    this.semanticsLabel,
  });

  final String data;
  final WdsTextStyle style;
  final WdsTextColor color;

  /// Promotes the chosen scale to its bold weight: `w700` for
  /// display/title, `w600` for everything else.
  final bool bold;

  /// Escape hatch for cases where no semantic role applies (illustrations,
  /// brand callouts, etc.). Prefer [color] in normal product code.
  final Color? colorOverride;

  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final type = context.wdsType;
    final base = switch (style) {
      WdsTextStyle.display1 => type.display1,
      WdsTextStyle.display2 => type.display2,
      WdsTextStyle.display3 => type.display3,
      WdsTextStyle.title1 => type.title1,
      WdsTextStyle.title2 => type.title2,
      WdsTextStyle.title3 => type.title3,
      WdsTextStyle.heading1 => type.heading1,
      WdsTextStyle.heading2 => type.heading2,
      WdsTextStyle.headline1 => type.headline1,
      WdsTextStyle.headline2 => type.headline2,
      WdsTextStyle.body1 => type.body1,
      WdsTextStyle.body1Reading => type.body1Reading,
      WdsTextStyle.body2 => type.body2,
      WdsTextStyle.body2Reading => type.body2Reading,
      WdsTextStyle.label1 => type.label1,
      WdsTextStyle.label1Reading => type.label1Reading,
      WdsTextStyle.label2 => type.label2,
      WdsTextStyle.caption1 => type.caption1,
      WdsTextStyle.caption2 => type.caption2,
    };

    final isDisplayLike = switch (style) {
      WdsTextStyle.display1 ||
      WdsTextStyle.display2 ||
      WdsTextStyle.display3 ||
      WdsTextStyle.title1 ||
      WdsTextStyle.title2 ||
      WdsTextStyle.title3 => true,
      _ => false,
    };

    final weight = bold
        ? (isDisplayLike ? WdsFontWeights.boldDisplay : WdsFontWeights.bold)
        : null;

    final resolvedColor = colorOverride ?? _resolveColor(context);

    return Text(
      data,
      style: base.copyWith(color: resolvedColor, fontWeight: weight),
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      softWrap: softWrap,
      semanticsLabel: semanticsLabel,
    );
  }

  Color _resolveColor(BuildContext context) {
    final colors = context.wdsColors;
    return switch (color) {
      WdsTextColor.normal => colors.labelNormal,
      WdsTextColor.strong => colors.labelStrong,
      WdsTextColor.neutral => colors.labelNeutral,
      WdsTextColor.alternative => colors.labelAlternative,
      WdsTextColor.assistive => colors.labelAssistive,
      WdsTextColor.disable => colors.labelDisable,
      WdsTextColor.primary => colors.primaryNormal,
      WdsTextColor.onPrimary => colors.onPrimary,
    };
  }
}
