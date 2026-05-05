import 'package:flutter/animation.dart';

/// Motion tokens — durations, easings, transition combos.
///
/// Source: `docs/foundations/00-motion.md`. Per spec, OS reduced-motion
/// should collapse all durations to [Duration.zero]. Use
/// [WdsMotion.respectReducedMotion] at the call site.
class WdsMotion {
  const WdsMotion._();

  // Duration
  static const Duration durationInstant = Duration.zero;
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationBase = Duration(milliseconds: 200);
  static const Duration durationSlow = Duration(milliseconds: 300);
  static const Duration durationPage = Duration(milliseconds: 400);

  // Easing
  static const Curve easingStandard = Curves.ease;
  static const Curve easingDecelerate = Curves.easeOut;
  static const Curve easingAccelerate = Curves.easeIn;
  static const Curve easingInOut = Curves.easeInOut;
  static const Curve easingSpring = Cubic(0.5, 0, 0.5, 1);
  static const Curve easingSharp = Cubic(0.8, 0, 0.2, 1);

  /// Returns [duration] unless OS reduced-motion is enabled, in which case
  /// returns [Duration.zero]. Pass `MediaQuery.disableAnimationsOf(context)`.
  static Duration respectReducedMotion(
    Duration duration, {
    required bool reducedMotion,
  }) => reducedMotion ? Duration.zero : duration;
}
