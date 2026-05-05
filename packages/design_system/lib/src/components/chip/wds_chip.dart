import 'package:flutter/material.dart';

import '../../foundations/wds_radius.dart';
import '../../foundations/wds_spacing.dart';
import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsChipSize { xsmall, small, medium, large }

enum WdsChipVariant { solid, outlined }

/// Toggleable pill-shaped chip — `docs/components/04-chip.md`.
///
/// Group selection logic (single/multi-select) belongs to the parent.
class WdsChip extends StatelessWidget {
  const WdsChip({
    super.key,
    required this.label,
    this.onTap,
    this.active = false,
    this.size = WdsChipSize.medium,
    this.variant = WdsChipVariant.solid,
    this.leading,
    this.trailing,
    this.disabled = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool active;
  final WdsChipSize size;
  final WdsChipVariant variant;
  final Widget? leading;
  final Widget? trailing;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final motion = context.wdsMotion;

    final font = switch (size) {
      WdsChipSize.xsmall => WdsTypographyTokens.caption2,
      WdsChipSize.small => WdsTypographyTokens.caption1,
      WdsChipSize.medium => WdsTypographyTokens.label2,
      WdsChipSize.large => WdsTypographyTokens.label1,
    };

    final padding = switch (size) {
      WdsChipSize.xsmall => const EdgeInsets.symmetric(
        horizontal: WdsSpacing.s8,
        vertical: WdsSpacing.s2,
      ),
      WdsChipSize.small => const EdgeInsets.symmetric(
        horizontal: WdsSpacing.s10,
        vertical: WdsSpacing.s4,
      ),
      WdsChipSize.medium => const EdgeInsets.symmetric(
        horizontal: WdsSpacing.s12,
        vertical: WdsSpacing.s6,
      ),
      WdsChipSize.large => const EdgeInsets.symmetric(
        horizontal: WdsSpacing.s14,
        vertical: WdsSpacing.s8,
      ),
    };

    final Color background;
    final Color foreground;
    final Color? borderColor;

    if (disabled) {
      background = variant == WdsChipVariant.solid
          ? colors.interactionDisable
          : Colors.transparent;
      foreground = colors.labelDisable;
      borderColor = variant == WdsChipVariant.outlined
          ? colors.lineNormalAlternative
          : null;
    } else if (variant == WdsChipVariant.solid) {
      background = active ? colors.primaryNormal : colors.fillNormal;
      foreground = active ? colors.onPrimary : colors.labelNormal;
      borderColor = null;
    } else {
      background = Colors.transparent;
      foreground = active ? colors.primaryNormal : colors.labelNormal;
      borderColor = active ? colors.primaryNormal : colors.lineNormalNeutral;
    }

    final content = <Widget>[
      if (leading != null) ...[
        IconTheme(
          data: IconThemeData(color: foreground, size: 14),
          child: leading!,
        ),
        const SizedBox(width: WdsSpacing.s4),
      ],
      Text(label, style: font.copyWith(color: foreground)),
      if (trailing != null) ...[
        const SizedBox(width: WdsSpacing.s4),
        IconTheme(
          data: IconThemeData(color: foreground, size: 14),
          child: trailing!,
        ),
      ],
    ];

    return Semantics(
      button: true,
      toggled: active,
      enabled: !disabled,
      child: AnimatedContainer(
        duration: motion.durationFast,
        curve: motion.easingStandard,
        decoration: BoxDecoration(
          color: background,
          borderRadius: WdsRadius.brFull,
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1)
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          shape: const StadiumBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: disabled ? null : onTap,
            child: Padding(
              padding: padding,
              child: Row(mainAxisSize: MainAxisSize.min, children: content),
            ),
          ),
        ),
      ),
    );
  }
}
