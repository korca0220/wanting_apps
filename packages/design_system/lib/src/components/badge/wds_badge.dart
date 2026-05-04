import 'package:flutter/material.dart';

import '../../foundations/wds_colors.dart';
import '../../foundations/wds_radius.dart';
import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsBadgeVariant { solid, outlined }

enum WdsBadgeSize { xsmall, small, medium }

/// Optional accent palette for solid variant. `neutral` is the default and
/// uses fill/normal + label/normal so badges blend with surface context;
/// the named accents tint the background and force a saturated foreground.
enum WdsBadgeAccent { neutral, redOrange, lime, cyan, violet, pink }

/// Static label for category / status / tag display.
///
/// Per spec, Badge is **non-interactive**. Use Chip when interactivity is
/// needed. Accent palette is the minimal subset wired into this lib —
/// covers the common social/product tag cases. Full 11-hue rollout is
/// tracked in `quality_report.md`.
class WdsBadge extends StatelessWidget {
  const WdsBadge({
    super.key,
    required this.label,
    this.variant = WdsBadgeVariant.solid,
    this.size = WdsBadgeSize.medium,
    this.accent = WdsBadgeAccent.neutral,
  });

  final String label;
  final WdsBadgeVariant variant;
  final WdsBadgeSize size;
  final WdsBadgeAccent accent;

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

  Color? get _accentBase => switch (accent) {
        WdsBadgeAccent.neutral => null,
        WdsBadgeAccent.redOrange => WdsColors.red50,
        WdsBadgeAccent.lime => WdsColors.lime50,
        WdsBadgeAccent.cyan => WdsColors.cyan50,
        WdsBadgeAccent.violet => WdsColors.violet50,
        WdsBadgeAccent.pink => WdsColors.pink50,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    final accentBase = _accentBase;
    final hasAccent = accentBase != null;

    final Color bg;
    final Color fg;
    final Border? border;

    if (variant == WdsBadgeVariant.outlined) {
      bg = Colors.transparent;
      fg = hasAccent ? accentBase : colors.labelNormal;
      border = Border.all(
        color: hasAccent ? accentBase : colors.lineNormalNeutral,
        width: 1,
      );
    } else if (hasAccent) {
      bg = accentBase.withValues(alpha: 0.16);
      fg = accentBase;
      border = null;
    } else {
      bg = colors.fillNormal;
      fg = colors.labelNormal;
      border = null;
    }

    return Container(
      padding: _padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.all(Radius.circular(_radius)),
        border: border,
      ),
      child: Text(label, style: _baseStyle.copyWith(color: fg)),
    );
  }
}
