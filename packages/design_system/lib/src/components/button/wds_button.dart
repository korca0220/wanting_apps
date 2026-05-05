import 'package:flutter/material.dart';

import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_color_scheme.dart';
import '../../theme/wds_radius_theme.dart';
import '../../theme/wds_theme_ext.dart';

/// Visual style of [WdsButton].
enum WdsButtonVariant { solid, outlined }

/// Color emphasis. `primary` is the main CTA, `assistive` is the lower-
/// emphasis surface action.
enum WdsButtonColor { primary, assistive }

/// Size step. See `docs/components/01-button.md` for padding/font mapping.
enum WdsButtonSize { small, medium, large }

/// Wanted-style button.
///
/// API contract (per `docs/components/01-button.md` "## API (Flutter)"):
/// - [onPressed] = `null` → disabled state.
/// - [loading] = `true` → child is hidden (size preserved) and a spinner
///   overlays the centre. `onPressed` is ignored while loading.
/// - [iconLeading] / [iconTrailing] insert before/after the child with a
///   token-driven gap.
/// - [iconOnly] forces square padding suitable for an icon-only button.
class WdsButton extends StatelessWidget {
  const WdsButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = WdsButtonVariant.solid,
    this.color = WdsButtonColor.primary,
    this.size = WdsButtonSize.medium,
    this.loading = false,
    this.iconLeading,
    this.iconTrailing,
    this.iconOnly = false,
    this.focusNode,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final WdsButtonVariant variant;
  final WdsButtonColor color;
  final WdsButtonSize size;
  final bool loading;
  final Widget? iconLeading;
  final Widget? iconTrailing;
  final bool iconOnly;
  final FocusNode? focusNode;

  bool get _enabled => onPressed != null && !loading;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final radii = context.wdsRadius;
    final spacing = context.wdsSpacing;

    final fontStyle = _fontFor(
      size: size,
      color: color,
      semanticColor: _foreground(colors),
    );
    final padding = _paddingFor(size, iconOnly: iconOnly);
    final gap = size == WdsButtonSize.small ? spacing.componentXs : 6.0;

    final style = _buildStyle(
      context: context,
      colors: colors,
      radius: _radiusFor(radii),
      padding: padding,
    );

    final content = _Content(
      iconLeading: iconLeading,
      iconTrailing: iconTrailing,
      gap: gap,
      iconOnly: iconOnly,
      loading: loading,
      spinnerColor: _foreground(colors),
      child: DefaultTextStyle.merge(style: fontStyle, child: child),
    );

    if (variant == WdsButtonVariant.outlined) {
      return OutlinedButton(
        onPressed: _enabled ? onPressed : null,
        focusNode: focusNode,
        style: style,
        child: content,
      );
    }
    return FilledButton(
      onPressed: _enabled ? onPressed : null,
      focusNode: focusNode,
      style: style,
      child: content,
    );
  }

  // ─── Style resolution ─────────────────────────────────────────────────

  ButtonStyle _buildStyle({
    required BuildContext context,
    required WdsColorScheme colors,
    required double radius,
    required EdgeInsets padding,
  }) {
    final fg = _foreground(colors);

    Color resolvedBg(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return _disabledBackground(colors);
      }
      if (variant == WdsButtonVariant.solid &&
          color == WdsButtonColor.primary) {
        if (states.contains(WidgetState.pressed)) return colors.primaryHeavy;
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused)) {
          return colors.primaryStrong;
        }
        return colors.primaryNormal;
      }
      if (variant == WdsButtonVariant.solid &&
          color == WdsButtonColor.assistive) {
        if (states.contains(WidgetState.pressed) ||
            states.contains(WidgetState.hovered)) {
          return colors.fillStrong;
        }
        return colors.fillNormal;
      }
      // outlined → transparent base, subtle fill on hover/press
      if (states.contains(WidgetState.pressed)) return colors.fillStrong;
      if (states.contains(WidgetState.hovered)) return colors.fillNormal;
      return Colors.transparent;
    }

    Color resolvedFg(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) return colors.labelAssistive;
      return fg;
    }

    BorderSide resolvedBorder(Set<WidgetState> states) {
      if (variant != WdsButtonVariant.outlined) return BorderSide.none;
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(color: colors.lineNormalAlternative, width: 1);
      }
      return BorderSide(color: colors.lineNormalNeutral, width: 1);
    }

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith(resolvedBg),
      foregroundColor: WidgetStateProperty.resolveWith(resolvedFg),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(padding),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
      ),
      side: WidgetStateProperty.resolveWith(resolvedBorder),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: const WidgetStatePropertyAll<Size>(Size.zero),
      elevation: const WidgetStatePropertyAll<double>(0),
      shadowColor: const WidgetStatePropertyAll<Color>(Colors.transparent),
      animationDuration: context.wdsMotion.durationBase,
    );
  }

  Color _foreground(WdsColorScheme colors) {
    if (variant == WdsButtonVariant.solid && color == WdsButtonColor.primary) {
      return colors.onPrimary;
    }
    if (variant == WdsButtonVariant.solid &&
        color == WdsButtonColor.assistive) {
      return colors.labelNeutral;
    }
    if (variant == WdsButtonVariant.outlined &&
        color == WdsButtonColor.primary) {
      return colors.primaryNormal;
    }
    return colors.labelNormal; // outlined assistive
  }

  Color _disabledBackground(WdsColorScheme colors) {
    if (variant == WdsButtonVariant.outlined) return Colors.transparent;
    return colors.interactionDisable;
  }

  double _radiusFor(WdsRadiusTheme radii) {
    switch (size) {
      case WdsButtonSize.small:
        return radii.button;
      case WdsButtonSize.medium:
        return radii.buttonMd;
      case WdsButtonSize.large:
        return radii.buttonLg;
    }
  }

  EdgeInsets _paddingFor(WdsButtonSize size, {required bool iconOnly}) {
    if (iconOnly) {
      switch (size) {
        case WdsButtonSize.small:
          return const EdgeInsets.all(7);
        case WdsButtonSize.medium:
          return const EdgeInsets.all(9);
        case WdsButtonSize.large:
          return const EdgeInsets.all(12);
      }
    }
    switch (size) {
      case WdsButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 14, vertical: 7);
      case WdsButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 9);
      case WdsButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 12);
    }
  }

  TextStyle _fontFor({
    required WdsButtonSize size,
    required WdsButtonColor color,
    required Color semanticColor,
  }) {
    final weight = color == WdsButtonColor.primary
        ? WdsFontWeights.bold
        : WdsFontWeights.medium;
    final base = switch (size) {
      WdsButtonSize.small => WdsTypographyTokens.label2,
      WdsButtonSize.medium => WdsTypographyTokens.body2,
      WdsButtonSize.large => WdsTypographyTokens.body1,
    };
    return base.copyWith(fontWeight: weight, color: semanticColor);
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.iconLeading,
    required this.iconTrailing,
    required this.gap,
    required this.iconOnly,
    required this.loading,
    required this.spinnerColor,
    required this.child,
  });

  final Widget? iconLeading;
  final Widget? iconTrailing;
  final double gap;
  final bool iconOnly;
  final bool loading;
  final Color spinnerColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final visible = !loading;
    final body = iconOnly
        ? child
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (iconLeading != null) ...[iconLeading!, SizedBox(width: gap)],
              Flexible(child: child),
              if (iconTrailing != null) ...[
                SizedBox(width: gap),
                iconTrailing!,
              ],
            ],
          );

    return Stack(
      alignment: Alignment.center,
      children: [
        // Hide content while loading but preserve intrinsic size so the
        // button width doesn't jump.
        Visibility(
          visible: visible,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: body,
        ),
        if (loading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
            ),
          ),
      ],
    );
  }
}
