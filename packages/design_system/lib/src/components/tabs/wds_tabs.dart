import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../foundations/wds_radius.dart';
import '../../foundations/wds_spacing.dart';
import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_color_scheme.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsTabsVariant { underline, pills }

class WdsTabItem<T> {
  const WdsTabItem({
    required this.value,
    required this.label,
    this.disabled = false,
  });

  final T value;
  final String label;
  final bool disabled;
}

/// Tab strip — `docs/components/26-tabs.md`.
///
/// Selection is controlled (`value` / `onChanged`). Panel rendering is the
/// caller's responsibility — the harness provides only the strip.
///
/// The active indicator slides between tabs: underline draws a single 2px
/// bar that animates between the selected tab's bounds; pills moves the
/// elevated background pill the same way. Tab widths can be variable —
/// positions are measured each frame after layout via post-frame callback.
class WdsTabs<T> extends StatefulWidget {
  const WdsTabs({
    super.key,
    required this.value,
    required this.onChanged,
    required this.tabs,
    this.variant = WdsTabsVariant.underline,
    this.fullWidth = false,
    this.scrollable = false,
  });

  final T value;
  final ValueChanged<T> onChanged;
  final List<WdsTabItem<T>> tabs;
  final WdsTabsVariant variant;
  final bool fullWidth;
  final bool scrollable;

  @override
  State<WdsTabs<T>> createState() => _WdsTabsState<T>();
}

class _WdsTabsState<T> extends State<WdsTabs<T>> {
  final GlobalKey _stripKey = GlobalKey();
  List<GlobalKey> _tabKeys = const [];
  Rect? _indicatorRect;

  @override
  void initState() {
    super.initState();
    _rebuildKeys();
  }

  @override
  void didUpdateWidget(WdsTabs<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _rebuildKeys();
    }
    SchedulerBinding.instance.addPostFrameCallback((_) => _updateIndicator());
  }

  void _rebuildKeys() {
    _tabKeys = List.generate(widget.tabs.length, (_) => GlobalKey());
  }

  void _updateIndicator() {
    if (!mounted) return;
    final idx = widget.tabs.indexWhere((t) => t.value == widget.value);
    if (idx < 0 || idx >= _tabKeys.length) return;
    final tabCtx = _tabKeys[idx].currentContext;
    final stripCtx = _stripKey.currentContext;
    if (tabCtx == null || stripCtx == null) return;
    final tabBox = tabCtx.findRenderObject();
    final stripBox = stripCtx.findRenderObject();
    if (tabBox is! RenderBox || stripBox is! RenderBox) return;
    if (!tabBox.hasSize || !stripBox.hasSize) return;
    final offset = tabBox.localToGlobal(Offset.zero, ancestor: stripBox);
    final next = offset & tabBox.size;
    if (_indicatorRect != next) {
      setState(() => _indicatorRect = next);
    }
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((_) => _updateIndicator());
    return widget.variant == WdsTabsVariant.underline
        ? _underline(context)
        : _pills(context);
  }

  Widget _underline(BuildContext context) {
    final colors = context.wdsColors;

    final tabs = <Widget>[
      for (var i = 0; i < widget.tabs.length; i++)
        KeyedSubtree(
          key: _tabKeys[i],
          child: _underlineTab(context, widget.tabs[i]),
        ),
    ];

    Widget row;
    if (widget.scrollable) {
      row = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: tabs),
      );
    } else if (widget.fullWidth) {
      row = Row(children: [for (final t in tabs) Expanded(child: t)]);
    } else {
      row = Row(mainAxisSize: MainAxisSize.min, children: tabs);
    }

    final indicatorAnimated = _indicatorRect == null
        ? const SizedBox.shrink()
        : AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            left: _indicatorRect!.left,
            top: _indicatorRect!.bottom - 2,
            width: _indicatorRect!.width,
            height: 2,
            child: Container(color: colors.primaryNormal),
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.lineNormalNeutral, width: 1),
        ),
      ),
      child: Stack(key: _stripKey, children: [row, indicatorAnimated]),
    );
  }

  Widget _underlineTab(BuildContext context, WdsTabItem<T> item) {
    final colors = context.wdsColors;
    final active = item.value == widget.value;
    final disabled = item.disabled;

    final fg = disabled
        ? colors.labelDisable
        : active
        ? colors.primaryNormal
        : colors.labelAlternative;

    return Semantics(
      selected: active,
      button: true,
      enabled: !disabled,
      child: InkWell(
        onTap: disabled ? null : () => widget.onChanged(item.value),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: WdsSpacing.s16,
            vertical: WdsSpacing.s10,
          ),
          alignment: Alignment.center,
          child: Text(
            item.label,
            style: WdsTypographyTokens.label1.copyWith(
              color: fg,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _pills(BuildContext context) {
    final colors = context.wdsColors;
    final shadows = context.wdsShadows;

    final tabs = <Widget>[
      for (var i = 0; i < widget.tabs.length; i++)
        KeyedSubtree(
          key: _tabKeys[i],
          child: _pillTab(context, widget.tabs[i], colors),
        ),
    ];

    final inner = widget.fullWidth
        ? Row(children: [for (final t in tabs) Expanded(child: t)])
        : Row(mainAxisSize: MainAxisSize.min, children: tabs);

    final pill = _indicatorRect == null
        ? const SizedBox.shrink()
        : AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            left: _indicatorRect!.left,
            top: _indicatorRect!.top,
            width: _indicatorRect!.width,
            height: _indicatorRect!.height,
            child: Container(
              decoration: BoxDecoration(
                color: colors.backgroundElevatedNormal,
                borderRadius: WdsRadius.brSm,
                boxShadow: shadows.normalXSmall,
              ),
            ),
          );

    return Container(
      decoration: BoxDecoration(
        color: colors.fillNormal,
        borderRadius: WdsRadius.brMd,
      ),
      padding: const EdgeInsets.all(WdsSpacing.s4),
      child: Stack(key: _stripKey, children: [pill, inner]),
    );
  }

  Widget _pillTab(
    BuildContext context,
    WdsTabItem<T> item,
    WdsColorScheme colors,
  ) {
    final active = item.value == widget.value;
    final disabled = item.disabled;

    final fg = disabled
        ? colors.labelDisable
        : active
        ? colors.labelNormal
        : colors.labelAlternative;

    return Semantics(
      selected: active,
      button: true,
      enabled: !disabled,
      child: Material(
        color: Colors.transparent,
        borderRadius: WdsRadius.brSm,
        child: InkWell(
          borderRadius: WdsRadius.brSm,
          onTap: disabled ? null : () => widget.onChanged(item.value),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: WdsSpacing.s14,
              vertical: WdsSpacing.s6,
            ),
            alignment: Alignment.center,
            child: Text(
              item.label,
              style: WdsTypographyTokens.label2.copyWith(
                color: fg,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
