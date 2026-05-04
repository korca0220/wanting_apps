import 'package:flutter/material.dart';

import '../../foundations/wds_radius.dart';
import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsBadgeVariant { solid, outlined }

enum WdsBadgeSize { xsmall, small, medium }

/// Static label for category / status / tag display.
///
/// Per spec, Badge is **non-interactive**. Use Chip when interactivity is
/// needed. Accent color group (`accent/{redOrange|lime|...}`) is not yet
/// wired — accent primitives are still being inlined into
/// `00-color.md`. Track in `quality_report.md`.
class WdsBadge extends StatelessWidget {
  const WdsBadge({
    super.key,
    required this.label,
    this.variant = WdsBadgeVariant.solid,
    this.size = WdsBadgeSize.medium,
  });

  final String label;
  final WdsBadgeVariant variant;
  final WdsBadgeSize size;

  EdgeInsets get _padding => switch (size) {
        WdsBadgeSize.xsmall => const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        WdsBadgeSize.small => const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        WdsBadgeSize.medium => const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      };

  double get _radius =>
      size == WdsBadgeSize.medium ? WdsRadius.md : WdsRadius.sm;

  TextStyle get _baseStyle => switch (size) {
        WdsBadgeSize.xsmall => WdsTypographyTokens.caption2,
        WdsBadgeSize.small => WdsTypographyTokens.caption1,
        WdsBadgeSize.medium => WdsTypographyTokens.label2,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    final bg = variant == WdsBadgeVariant.solid
        ? colors.fillNormal
        : Colors.transparent;
    final fg = colors.labelNormal;
    final border = variant == WdsBadgeVariant.outlined
        ? Border.all(color: colors.lineNormalNeutral, width: 1)
        : null;

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
        border: border,
      ),
      child: Text(
        label,
        style: _baseStyle.copyWith(color: fg),
      ),
    );
  }
}
