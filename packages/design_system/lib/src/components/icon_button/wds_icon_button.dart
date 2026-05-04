import 'package:flutter/material.dart';

import '../../theme/wds_color_scheme.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsIconButtonVariant { normal, background, outlined, solid }

enum WdsIconButtonSize { small, medium }

/// Pill-shaped icon-only button. Distinct from `WdsButton(iconOnly: true)`
/// because per `docs/components/09-icon-button.md` the icon-color
/// transition is a first-class concern.
class WdsIconButton extends StatelessWidget {
  const WdsIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.semanticLabel,
    this.variant = WdsIconButtonVariant.normal,
    this.size = WdsIconButtonSize.medium,
    this.color,
    this.interactionColor,
    this.focusNode,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  /// Required per spec — icon-only buttons must have an accessible name.
  final String semanticLabel;

  final WdsIconButtonVariant variant;
  final WdsIconButtonSize size;

  /// Default icon color. Falls back to `labelNormal` (or `onPrimary` for
  /// solid variant).
  final Color? color;

  /// Hover/Pressed icon color. Defaults to `color`.
  final Color? interactionColor;

  final FocusNode? focusNode;

  double get _diameter => size == WdsIconButtonSize.small ? 32 : 40;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    Color resolvedFg(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) return colors.labelDisable;
      final base = color ?? _defaultForeground(colors);
      if (interactionColor != null &&
          (states.contains(WidgetState.pressed) ||
              states.contains(WidgetState.hovered))) {
        return interactionColor!;
      }
      return base;
    }

    Color resolvedBg(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return variant == WdsIconButtonVariant.solid
            ? colors.interactionDisable
            : Colors.transparent;
      }
      switch (variant) {
        case WdsIconButtonVariant.normal:
          if (states.contains(WidgetState.pressed)) return colors.fillStrong;
          if (states.contains(WidgetState.hovered)) return colors.fillNormal;
          return Colors.transparent;
        case WdsIconButtonVariant.background:
          if (states.contains(WidgetState.pressed)) return colors.fillStrong;
          return colors.fillNormal;
        case WdsIconButtonVariant.outlined:
          if (states.contains(WidgetState.pressed)) return colors.fillStrong;
          if (states.contains(WidgetState.hovered)) return colors.fillNormal;
          return Colors.transparent;
        case WdsIconButtonVariant.solid:
          if (states.contains(WidgetState.pressed)) return colors.primaryHeavy;
          if (states.contains(WidgetState.hovered)) return colors.primaryStrong;
          return colors.primaryNormal;
      }
    }

    BorderSide resolvedBorder(Set<WidgetState> states) {
      if (variant != WdsIconButtonVariant.outlined) return BorderSide.none;
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(color: colors.lineNormalAlternative, width: 1);
      }
      return BorderSide(color: colors.lineNormalNeutral, width: 1);
    }

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(resolvedBg),
      foregroundColor: WidgetStateProperty.resolveWith(resolvedFg),
      iconColor: WidgetStateProperty.resolveWith(resolvedFg),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      shape: const WidgetStatePropertyAll<OutlinedBorder>(
        CircleBorder(),
      ),
      side: WidgetStateProperty.resolveWith(resolvedBorder),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.zero,
      ),
      minimumSize: WidgetStatePropertyAll<Size>(Size(_diameter, _diameter)),
      fixedSize: WidgetStatePropertyAll<Size>(Size(_diameter, _diameter)),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      animationDuration: context.wdsMotion.durationBase,
    );

    return Semantics(
      button: true,
      label: semanticLabel,
      child: SizedBox(
        width: _diameter,
        height: _diameter,
        child: IconButton(
          onPressed: onPressed,
          focusNode: focusNode,
          style: style,
          icon: IconTheme(
            data: IconThemeData(size: size == WdsIconButtonSize.small ? 16 : 20),
            child: icon,
          ),
        ),
      ),
    );
  }

  Color _defaultForeground(WdsColorScheme colors) {
    return variant == WdsIconButtonVariant.solid
        ? colors.onPrimary
        : colors.labelNormal;
  }
}
