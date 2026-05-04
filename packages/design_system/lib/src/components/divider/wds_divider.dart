import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

/// Horizontal or vertical divider line.
///
/// All visual props (color/thickness/length) are overridable.
class WdsDivider extends StatelessWidget {
  const WdsDivider({
    super.key,
    this.vertical = false,
    this.thickness = 1,
    this.length,
    this.color,
  });

  final bool vertical;
  final double thickness;

  /// Pixel length along the main axis. `null` → fill parent (`double.infinity`).
  final double? length;

  /// Override the line colour. Defaults to `lineNormalNeutral`.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.wdsColors.lineNormalNeutral;
    return Semantics(
      child: SizedBox(
        width: vertical ? thickness : (length ?? double.infinity),
        height: vertical ? (length ?? double.infinity) : thickness,
        child: ColoredBox(color: c),
      ),
    );
  }
}
