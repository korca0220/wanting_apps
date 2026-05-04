import 'package:flutter/material.dart';

import '../foundations/wds_typography_tokens.dart';

/// Typography ThemeExtension — provides TextStyles with the ambient label
/// color baked in for the current brightness. Components reading from this
/// extension don't need to also fetch the color scheme to render text.
@immutable
class WdsTypography extends ThemeExtension<WdsTypography> {
  const WdsTypography({
    required this.display1,
    required this.display2,
    required this.display3,
    required this.title1,
    required this.title2,
    required this.title3,
    required this.heading1,
    required this.heading2,
    required this.headline1,
    required this.headline2,
    required this.body1,
    required this.body1Reading,
    required this.body2,
    required this.body2Reading,
    required this.label1,
    required this.label1Reading,
    required this.label2,
    required this.caption1,
    required this.caption2,
  });

  final TextStyle display1;
  final TextStyle display2;
  final TextStyle display3;
  final TextStyle title1;
  final TextStyle title2;
  final TextStyle title3;
  final TextStyle heading1;
  final TextStyle heading2;
  final TextStyle headline1;
  final TextStyle headline2;
  final TextStyle body1;
  final TextStyle body1Reading;
  final TextStyle body2;
  final TextStyle body2Reading;
  final TextStyle label1;
  final TextStyle label1Reading;
  final TextStyle label2;
  final TextStyle caption1;
  final TextStyle caption2;

  factory WdsTypography.from({required Color labelColor}) {
    TextStyle paint(TextStyle s) => s.copyWith(color: labelColor);
    return WdsTypography(
      display1: paint(WdsTypographyTokens.display1),
      display2: paint(WdsTypographyTokens.display2),
      display3: paint(WdsTypographyTokens.display3),
      title1: paint(WdsTypographyTokens.title1),
      title2: paint(WdsTypographyTokens.title2),
      title3: paint(WdsTypographyTokens.title3),
      heading1: paint(WdsTypographyTokens.heading1),
      heading2: paint(WdsTypographyTokens.heading2),
      headline1: paint(WdsTypographyTokens.headline1),
      headline2: paint(WdsTypographyTokens.headline2),
      body1: paint(WdsTypographyTokens.body1),
      body1Reading: paint(WdsTypographyTokens.body1Reading),
      body2: paint(WdsTypographyTokens.body2),
      body2Reading: paint(WdsTypographyTokens.body2Reading),
      label1: paint(WdsTypographyTokens.label1),
      label1Reading: paint(WdsTypographyTokens.label1Reading),
      label2: paint(WdsTypographyTokens.label2),
      caption1: paint(WdsTypographyTokens.caption1),
      caption2: paint(WdsTypographyTokens.caption2),
    );
  }

  @override
  WdsTypography copyWith({
    TextStyle? display1,
    TextStyle? display2,
    TextStyle? display3,
    TextStyle? title1,
    TextStyle? title2,
    TextStyle? title3,
    TextStyle? heading1,
    TextStyle? heading2,
    TextStyle? headline1,
    TextStyle? headline2,
    TextStyle? body1,
    TextStyle? body1Reading,
    TextStyle? body2,
    TextStyle? body2Reading,
    TextStyle? label1,
    TextStyle? label1Reading,
    TextStyle? label2,
    TextStyle? caption1,
    TextStyle? caption2,
  }) {
    return WdsTypography(
      display1: display1 ?? this.display1,
      display2: display2 ?? this.display2,
      display3: display3 ?? this.display3,
      title1: title1 ?? this.title1,
      title2: title2 ?? this.title2,
      title3: title3 ?? this.title3,
      heading1: heading1 ?? this.heading1,
      heading2: heading2 ?? this.heading2,
      headline1: headline1 ?? this.headline1,
      headline2: headline2 ?? this.headline2,
      body1: body1 ?? this.body1,
      body1Reading: body1Reading ?? this.body1Reading,
      body2: body2 ?? this.body2,
      body2Reading: body2Reading ?? this.body2Reading,
      label1: label1 ?? this.label1,
      label1Reading: label1Reading ?? this.label1Reading,
      label2: label2 ?? this.label2,
      caption1: caption1 ?? this.caption1,
      caption2: caption2 ?? this.caption2,
    );
  }

  @override
  WdsTypography lerp(ThemeExtension<WdsTypography>? other, double t) {
    if (other is! WdsTypography) return this;
    TextStyle lerpS(TextStyle a, TextStyle b) => TextStyle.lerp(a, b, t)!;
    return WdsTypography(
      display1: lerpS(display1, other.display1),
      display2: lerpS(display2, other.display2),
      display3: lerpS(display3, other.display3),
      title1: lerpS(title1, other.title1),
      title2: lerpS(title2, other.title2),
      title3: lerpS(title3, other.title3),
      heading1: lerpS(heading1, other.heading1),
      heading2: lerpS(heading2, other.heading2),
      headline1: lerpS(headline1, other.headline1),
      headline2: lerpS(headline2, other.headline2),
      body1: lerpS(body1, other.body1),
      body1Reading: lerpS(body1Reading, other.body1Reading),
      body2: lerpS(body2, other.body2),
      body2Reading: lerpS(body2Reading, other.body2Reading),
      label1: lerpS(label1, other.label1),
      label1Reading: lerpS(label1Reading, other.label1Reading),
      label2: lerpS(label2, other.label2),
      caption1: lerpS(caption1, other.caption1),
      caption2: lerpS(caption2, other.caption2),
    );
  }
}
