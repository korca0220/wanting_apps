import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

enum WdsTooltipSize { small, medium }

/// Tooltip with token-styled background/typography.
///
/// Wraps Flutter's [Tooltip] (long-press on mobile, hover on desktop). The
/// `mode=click`/`always` modes from the spec are deferred — they require an
/// `OverlayPortal`-based custom implementation. Tracked in 05-tooltip.md.
class WdsTooltip extends StatelessWidget {
  const WdsTooltip({
    super.key,
    required this.message,
    required this.child,
    this.size = WdsTooltipSize.medium,
    this.shortcut,
  });

  final String message;
  final Widget child;
  final WdsTooltipSize size;

  /// Optional keyboard-shortcut hint shown after the message (e.g., `⌘C`).
  final String? shortcut;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;
    final shadows = context.wdsShadows;

    final textStyle = (size == WdsTooltipSize.small ? type.caption1 : type.label2)
        .copyWith(color: colors.inverseLabel);

    final padding = size == WdsTooltipSize.small
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

    final radius = size == WdsTooltipSize.small ? 6.0 : 8.0;

    return Tooltip(
      richMessage: shortcut == null
          ? null
          : TextSpan(
              text: '$message  ',
              style: textStyle,
              children: [
                TextSpan(
                  text: shortcut!,
                  style: textStyle.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
      message: shortcut == null ? message : '',
      textStyle: textStyle,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.inverseBackground,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadows.normalMedium,
      ),
      waitDuration: const Duration(milliseconds: 500),
      showDuration: const Duration(seconds: 2),
      verticalOffset: 12,
      preferBelow: false,
      child: child,
    );
  }
}
