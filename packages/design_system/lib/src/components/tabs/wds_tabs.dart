import 'package:flutter/material.dart';

import '../../foundations/wds_radius.dart';
import '../../foundations/wds_spacing.dart';
import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_color_scheme.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsTabsVariant { underline, pills }

class WdsTabItem<T> {
  const WdsTabItem({required this.value, required this.label, this.disabled = false});

  final T value;
  final String label;
  final bool disabled;
}

/// Tab strip — `docs/components/26-tabs.md`.
///
/// Selection is controlled (`value` / `onChanged`). Panel rendering is the
/// caller's responsibility — the harness provides only the strip.
///
/// NOTE: continuous slide indicator is not implemented; underline draws a
/// per-tab bottom border that snaps on selection change. Tracked as a
/// follow-up if motion fidelity becomes important.
class WdsTabs<T> extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return variant == WdsTabsVariant.underline
        ? _underline(context)
        : _pills(context);
  }

  Widget _underline(BuildContext context) {
    final colors = context.wdsColors;

    final children = <Widget>[
      for (final t in tabs) _underlineTab(context, t),
    ];

    Widget strip;
    if (scrollable) {
      strip = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: children),
      );
    } else if (fullWidth) {
      strip = Row(
        children: [for (final c in children) Expanded(child: c)],
      );
    } else {
      strip = Row(mainAxisSize: MainAxisSize.min, children: children);
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.lineNormalNeutral, width: 1),
        ),
      ),
      child: strip,
    );
  }

  Widget _underlineTab(BuildContext context, WdsTabItem<T> item) {
    final colors = context.wdsColors;
    final active = item.value == value;
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
        onTap: disabled ? null : () => onChanged(item.value),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: WdsSpacing.s16, vertical: WdsSpacing.s10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: active ? colors.primaryNormal : Colors.transparent,
                width: 2,
              ),
            ),
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

    final children = <Widget>[
      for (final t in tabs) _pillTab(context, t, colors, shadows.normalXSmall),
    ];

    final inner = fullWidth
        ? Row(children: [for (final c in children) Expanded(child: c)])
        : Row(mainAxisSize: MainAxisSize.min, children: children);

    return Container(
      decoration: BoxDecoration(
        color: colors.fillNormal,
        borderRadius: WdsRadius.brMd,
      ),
      padding: const EdgeInsets.all(WdsSpacing.s4),
      child: inner,
    );
  }

  Widget _pillTab(
    BuildContext context,
    WdsTabItem<T> item,
    WdsColorScheme colors,
    List<BoxShadow> activeShadow,
  ) {
    final active = item.value == value;
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
          onTap: disabled ? null : () => onChanged(item.value),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: WdsSpacing.s14, vertical: WdsSpacing.s6),
            decoration: BoxDecoration(
              color:
                  active ? colors.backgroundElevatedNormal : Colors.transparent,
              borderRadius: WdsRadius.brSm,
              boxShadow: active ? activeShadow : null,
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
