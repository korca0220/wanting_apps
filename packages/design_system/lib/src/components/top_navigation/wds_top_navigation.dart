import 'package:flutter/material.dart';

import '../../foundations/wds_spacing.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsTopNavigationVariant { defaultCentered, leading, emphasized, transparent }

/// Top header bar — `docs/components/25-top-navigation.md`.
///
/// `defaultCentered` mirrors iOS-style (centered title, leading + trailing
/// reserved). `leading` aligns the title to the start. `emphasized` doubles
/// height for full-modal headers. `transparent` removes background/border
/// so the bar can overlay hero artwork.
class WdsTopNavigation extends StatelessWidget {
  const WdsTopNavigation({
    super.key,
    this.title,
    this.leading,
    this.trailing,
    this.variant = WdsTopNavigationVariant.defaultCentered,
  });

  final Widget? title;
  final Widget? leading;
  final Widget? trailing;
  final WdsTopNavigationVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;

    final isEmphasized = variant == WdsTopNavigationVariant.emphasized;
    final isTransparent = variant == WdsTopNavigationVariant.transparent;
    final isCentered = variant == WdsTopNavigationVariant.defaultCentered;

    final height = isEmphasized ? 72.0 : 56.0;

    final titleStyle = isEmphasized
        ? type.title3.copyWith(
            color: colors.labelStrong, fontWeight: FontWeight.w700)
        : type.headline2.copyWith(
            color: colors.labelNormal, fontWeight: FontWeight.w700);

    final reservedSlotWidth = 48.0;

    Widget titleArea = title == null
        ? const SizedBox.shrink()
        : DefaultTextStyle.merge(
            style: titleStyle,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            child: title!,
          );

    final children = <Widget>[
      SizedBox(
        width: reservedSlotWidth,
        child: leading == null
            ? const SizedBox.shrink()
            : Align(alignment: Alignment.centerLeft, child: leading),
      ),
      Expanded(
        child: Align(
          alignment: isCentered ? Alignment.center : Alignment.centerLeft,
          child: titleArea,
        ),
      ),
      SizedBox(
        width: reservedSlotWidth,
        child: trailing == null
            ? const SizedBox.shrink()
            : Align(alignment: Alignment.centerRight, child: trailing),
      ),
    ];

    return Semantics(
      header: true,
      child: Material(
        color:
            isTransparent ? Colors.transparent : colors.backgroundElevatedNormal,
        child: SafeArea(
          bottom: false,
          child: DecoratedBox(
            decoration: BoxDecoration(
              border: isTransparent
                  ? null
                  : Border(
                      bottom:
                          BorderSide(color: colors.lineNormalNeutral, width: 1),
                    ),
            ),
            child: SizedBox(
              height: height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: WdsSpacing.s4),
                child: Row(children: children),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
