import 'package:flutter/material.dart';

import '../foundations/wds_motion.dart';

/// Motion ThemeExtension — exposed via ThemeExtension so consumers can
/// override animation timing per theme/test if needed.
@immutable
class WdsMotionTheme extends ThemeExtension<WdsMotionTheme> {
  const WdsMotionTheme({
    required this.durationInstant,
    required this.durationFast,
    required this.durationBase,
    required this.durationSlow,
    required this.durationPage,
    required this.easingStandard,
    required this.easingDecelerate,
    required this.easingAccelerate,
    required this.easingInOut,
    required this.easingSpring,
    required this.easingSharp,
  });

  final Duration durationInstant;
  final Duration durationFast;
  final Duration durationBase;
  final Duration durationSlow;
  final Duration durationPage;

  final Curve easingStandard;
  final Curve easingDecelerate;
  final Curve easingAccelerate;
  final Curve easingInOut;
  final Curve easingSpring;
  final Curve easingSharp;

  factory WdsMotionTheme.standard() => const WdsMotionTheme(
    durationInstant: WdsMotion.durationInstant,
    durationFast: WdsMotion.durationFast,
    durationBase: WdsMotion.durationBase,
    durationSlow: WdsMotion.durationSlow,
    durationPage: WdsMotion.durationPage,
    easingStandard: WdsMotion.easingStandard,
    easingDecelerate: WdsMotion.easingDecelerate,
    easingAccelerate: WdsMotion.easingAccelerate,
    easingInOut: WdsMotion.easingInOut,
    easingSpring: WdsMotion.easingSpring,
    easingSharp: WdsMotion.easingSharp,
  );

  @override
  WdsMotionTheme copyWith({
    Duration? durationInstant,
    Duration? durationFast,
    Duration? durationBase,
    Duration? durationSlow,
    Duration? durationPage,
    Curve? easingStandard,
    Curve? easingDecelerate,
    Curve? easingAccelerate,
    Curve? easingInOut,
    Curve? easingSpring,
    Curve? easingSharp,
  }) {
    return WdsMotionTheme(
      durationInstant: durationInstant ?? this.durationInstant,
      durationFast: durationFast ?? this.durationFast,
      durationBase: durationBase ?? this.durationBase,
      durationSlow: durationSlow ?? this.durationSlow,
      durationPage: durationPage ?? this.durationPage,
      easingStandard: easingStandard ?? this.easingStandard,
      easingDecelerate: easingDecelerate ?? this.easingDecelerate,
      easingAccelerate: easingAccelerate ?? this.easingAccelerate,
      easingInOut: easingInOut ?? this.easingInOut,
      easingSpring: easingSpring ?? this.easingSpring,
      easingSharp: easingSharp ?? this.easingSharp,
    );
  }

  @override
  WdsMotionTheme lerp(ThemeExtension<WdsMotionTheme>? other, double t) {
    if (other is! WdsMotionTheme) return this;
    return t < 0.5 ? this : other;
  }
}
