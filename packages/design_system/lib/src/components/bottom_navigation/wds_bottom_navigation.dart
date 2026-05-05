import 'package:flutter/material.dart';

import '../../foundations/wds_spacing.dart';
import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsBottomNavigationVariant { withLabel, iconOnly }

/// Item descriptor for [WdsBottomNavigation].
class WdsBottomNavigationItem {
  const WdsBottomNavigationItem({
    required this.icon,
    required this.label,
    this.activeIcon,
    this.badge,
  });

  final Widget icon;
  final Widget? activeIcon;
  final String label;

  /// Notification adornment — typically a small dot or count.
  final Widget? badge;
}

/// Mobile bottom tab bar — `docs/components/23-bottom-navigation.md`.
///
/// 2–5 items, equal flex distribution, safe-area inset applied.
class WdsBottomNavigation extends StatelessWidget {
  const WdsBottomNavigation({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.variant = WdsBottomNavigationVariant.withLabel,
  }) : assert(
         items.length >= 2 && items.length <= 5,
         '2–5 items per docs/components/23-bottom-navigation.md',
       );

  final List<WdsBottomNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final WdsBottomNavigationVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.backgroundElevatedNormal,
          border: Border(
            top: BorderSide(color: colors.lineNormalNeutral, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: variant == WdsBottomNavigationVariant.iconOnly ? 56 : 64,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _Item(
                      item: items[i],
                      active: i == currentIndex,
                      onTap: () => onTap(i),
                      variant: variant,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.item,
    required this.active,
    required this.onTap,
    required this.variant,
  });

  final WdsBottomNavigationItem item;
  final bool active;
  final VoidCallback onTap;
  final WdsBottomNavigationVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final fg = active ? colors.primaryNormal : colors.labelAlternative;
    final iconWidget = (active ? (item.activeIcon ?? item.icon) : item.icon);

    Widget icon = IconTheme(
      data: IconThemeData(color: fg, size: 24),
      child: iconWidget,
    );

    if (item.badge != null) {
      icon = Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          Positioned(top: -2, right: -2, child: item.badge!),
        ],
      );
    }

    final children = <Widget>[
      icon,
      if (variant == WdsBottomNavigationVariant.withLabel) ...[
        const SizedBox(height: WdsSpacing.s2),
        Text(
          item.label,
          style: WdsTypographyTokens.caption1.copyWith(
            color: fg,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    ];

    return Semantics(
      button: true,
      label: item.label,
      selected: active,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: WdsSpacing.s4,
              horizontal: WdsSpacing.s8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
