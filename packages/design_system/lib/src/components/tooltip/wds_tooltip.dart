import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

enum WdsTooltipSize { small, medium }

enum WdsTooltipMode {
  /// Standard hover (desktop) / long-press (mobile) trigger. Uses Flutter's
  /// built-in [Tooltip].
  hover,

  /// Toggles on tap. Stays open until the next outside tap or repeat tap.
  click,

  /// Pinned — visible while the widget is mounted. Useful for onboarding
  /// hints or coach marks.
  always,
}

enum WdsTooltipPlacement { top, bottom }

/// Tooltip with token-styled background/typography.
///
/// Hover mode delegates to Flutter's [Tooltip] (long-press on mobile,
/// hover on desktop). Click/always modes drive an `OverlayPortal` so the
/// tooltip lives outside the host widget's layout and floats above other
/// content. Placement is fixed (top by default) — auto-flip is not yet
/// implemented; track in `docs/components/05-tooltip.md`.
class WdsTooltip extends StatefulWidget {
  const WdsTooltip({
    super.key,
    required this.message,
    required this.child,
    this.size = WdsTooltipSize.medium,
    this.shortcut,
    this.mode = WdsTooltipMode.hover,
    this.placement = WdsTooltipPlacement.top,
  });

  final String message;
  final Widget child;
  final WdsTooltipSize size;

  /// Optional keyboard-shortcut hint shown after the message (e.g., `⌘C`).
  final String? shortcut;

  final WdsTooltipMode mode;
  final WdsTooltipPlacement placement;

  @override
  State<WdsTooltip> createState() => _WdsTooltipState();
}

class _WdsTooltipState extends State<WdsTooltip> {
  final OverlayPortalController _portal = OverlayPortalController();
  final LayerLink _link = LayerLink();

  @override
  void initState() {
    super.initState();
    if (widget.mode == WdsTooltipMode.always) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _portal.show());
    }
  }

  @override
  void didUpdateWidget(WdsTooltip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mode != widget.mode) {
      if (widget.mode == WdsTooltipMode.always) {
        if (!_portal.isShowing) _portal.show();
      } else if (oldWidget.mode == WdsTooltipMode.always) {
        if (_portal.isShowing) _portal.hide();
      }
    }
  }

  void _toggle() {
    if (_portal.isShowing) {
      _portal.hide();
    } else {
      _portal.show();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mode == WdsTooltipMode.hover) {
      return _hoverTooltip(context);
    }

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _portal,
        overlayChildBuilder: _buildOverlay,
        child: widget.mode == WdsTooltipMode.click
            ? _ClickWrapper(onTap: _toggle, child: widget.child)
            : widget.child,
      ),
    );
  }

  Widget _hoverTooltip(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;
    final shadows = context.wdsShadows;

    final textStyle =
        (widget.size == WdsTooltipSize.small ? type.caption1 : type.label2)
            .copyWith(color: colors.inverseLabel);

    final padding = widget.size == WdsTooltipSize.small
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

    final radius = widget.size == WdsTooltipSize.small ? 6.0 : 8.0;

    return Tooltip(
      richMessage: widget.shortcut == null
          ? null
          : TextSpan(
              text: '${widget.message}  ',
              style: textStyle,
              children: [
                TextSpan(
                  text: widget.shortcut!,
                  style: textStyle.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
      message: widget.shortcut == null ? widget.message : '',
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
      preferBelow: widget.placement == WdsTooltipPlacement.bottom,
      child: widget.child,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;
    final shadows = context.wdsShadows;

    final textStyle =
        (widget.size == WdsTooltipSize.small ? type.caption1 : type.label2)
            .copyWith(color: colors.inverseLabel);

    final padding = widget.size == WdsTooltipSize.small
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 6);

    final radius = widget.size == WdsTooltipSize.small ? 6.0 : 8.0;

    final bubble = Material(
      color: Colors.transparent,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: colors.inverseBackground,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: shadows.normalMedium,
        ),
        child: widget.shortcut == null
            ? Text(widget.message, style: textStyle)
            : Text.rich(
                TextSpan(
                  text: '${widget.message}  ',
                  style: textStyle,
                  children: [
                    TextSpan(
                      text: widget.shortcut!,
                      style: textStyle.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
      ),
    );

    final aboveTarget = widget.placement == WdsTooltipPlacement.top;
    final followerOffset = aboveTarget
        ? const Offset(0, -8)
        : const Offset(0, 8);
    final targetAnchor = aboveTarget
        ? Alignment.topCenter
        : Alignment.bottomCenter;
    final followerAnchor = aboveTarget
        ? Alignment.bottomCenter
        : Alignment.topCenter;

    return Stack(
      children: [
        // Outside-tap dismiss for click mode (always mode stays pinned).
        if (widget.mode == WdsTooltipMode.click)
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => _portal.hide(),
            ),
          ),
        CompositedTransformFollower(
          link: _link,
          offset: followerOffset,
          targetAnchor: targetAnchor,
          followerAnchor: followerAnchor,
          showWhenUnlinked: false,
          child: bubble,
        ),
      ],
    );
  }
}

class _ClickWrapper extends StatelessWidget {
  const _ClickWrapper({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: child,
    );
  }
}
