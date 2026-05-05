import 'package:flutter/material.dart';

import '../foundations/wds_radius.dart';

/// Semantic radius aliases (button, input, card, etc.).
@immutable
class WdsRadiusTheme extends ThemeExtension<WdsRadiusTheme> {
  const WdsRadiusTheme({
    required this.button,
    required this.buttonMd,
    required this.buttonLg,
    required this.input,
    required this.badge,
    required this.tooltip,
    required this.card,
    required this.thumbnail,
    required this.modal,
    required this.modalLarge,
    required this.pill,
  });

  /// Default button radius (small/icon variants) — 8px.
  final double button;

  /// Medium button radius — 10px (Inferred).
  final double buttonMd;

  /// Large button radius — 12px.
  final double buttonLg;

  final double input;
  final double badge;
  final double tooltip;
  final double card;
  final double thumbnail;
  final double modal;
  final double modalLarge;

  /// `radius/full` — circular avatars, switches, pills.
  final double pill;

  factory WdsRadiusTheme.standard() => const WdsRadiusTheme(
    button: WdsRadius.md,
    buttonMd: WdsRadius.btnMd,
    buttonLg: WdsRadius.lg,
    input: WdsRadius.md,
    badge: WdsRadius.md,
    tooltip: WdsRadius.sm,
    card: WdsRadius.lg,
    thumbnail: WdsRadius.lg,
    modal: WdsRadius.xl,
    modalLarge: WdsRadius.xl2,
    pill: WdsRadius.full,
  );

  @override
  WdsRadiusTheme copyWith({
    double? button,
    double? buttonMd,
    double? buttonLg,
    double? input,
    double? badge,
    double? tooltip,
    double? card,
    double? thumbnail,
    double? modal,
    double? modalLarge,
    double? pill,
  }) {
    return WdsRadiusTheme(
      button: button ?? this.button,
      buttonMd: buttonMd ?? this.buttonMd,
      buttonLg: buttonLg ?? this.buttonLg,
      input: input ?? this.input,
      badge: badge ?? this.badge,
      tooltip: tooltip ?? this.tooltip,
      card: card ?? this.card,
      thumbnail: thumbnail ?? this.thumbnail,
      modal: modal ?? this.modal,
      modalLarge: modalLarge ?? this.modalLarge,
      pill: pill ?? this.pill,
    );
  }

  @override
  WdsRadiusTheme lerp(ThemeExtension<WdsRadiusTheme>? other, double t) {
    if (other is! WdsRadiusTheme) return this;
    double l(double a, double b) => a + (b - a) * t;
    return WdsRadiusTheme(
      button: l(button, other.button),
      buttonMd: l(buttonMd, other.buttonMd),
      buttonLg: l(buttonLg, other.buttonLg),
      input: l(input, other.input),
      badge: l(badge, other.badge),
      tooltip: l(tooltip, other.tooltip),
      card: l(card, other.card),
      thumbnail: l(thumbnail, other.thumbnail),
      modal: l(modal, other.modal),
      modalLarge: l(modalLarge, other.modalLarge),
      pill: l(pill, other.pill),
    );
  }
}
