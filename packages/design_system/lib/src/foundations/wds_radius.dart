import 'package:flutter/painting.dart';

/// Border radius tokens — 5 standard steps + full.
///
/// Source: `docs/foundations/00-border-radius.md`. Note: radius foundation
/// is "Inferred" from inline values; designer review pending.
class WdsRadius {
  const WdsRadius._();

  static const double none = 0;
  static const double sm = 6;
  static const double md = 8;

  /// Mid-step (~10px) used by medium-sized buttons. Tracked as a "radius
  /// token candidate" in `01-button.md`. Promoted here for code reuse.
  static const double btnMd = 10;

  static const double lg = 12;
  static const double xl = 16;
  static const double xl2 = 20;
  static const double full = 9999;

  // BorderRadius helpers
  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brBtnMd = BorderRadius.all(Radius.circular(btnMd));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius brXl2 = BorderRadius.all(Radius.circular(xl2));
  static const BorderRadius brFull = BorderRadius.all(Radius.circular(full));
}
