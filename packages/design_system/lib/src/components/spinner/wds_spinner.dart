import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

enum WdsSpinnerVariant { circular, wanted }

/// Indeterminate progress indicator.
///
/// `circular` — single-colour rotating arc (1s linear cycle).
/// `wanted` — brand 4-colour cycle. Currently rendered as `circular` with
/// the primary colour; full 4-stage colour cycle (primary →
/// accent/lightBlue → accent/violet → accent/blue) is tracked alongside
/// accent token rollout. See `docs/components/19-spinner.md` and
/// `docs/foundations/00-color.md` (accent families).
class WdsSpinner extends StatelessWidget {
  const WdsSpinner({
    super.key,
    this.variant = WdsSpinnerVariant.circular,
    this.size = 24,
    this.color,
    this.semanticLabel = 'Loading',
  });

  final WdsSpinnerVariant variant;
  final double size;
  final Color? color;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final stroke = (size * 0.1).clamp(1.5, 4.0);
    final c = color ??
        (variant == WdsSpinnerVariant.wanted
            ? colors.primaryNormal
            : colors.labelNormal);

    return Semantics(
      label: semanticLabel,
      liveRegion: true,
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: stroke,
          valueColor: AlwaysStoppedAnimation<Color>(c),
        ),
      ),
    );
  }
}
