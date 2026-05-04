import 'package:flutter/material.dart';

import '../../foundations/wds_colors.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsAvatarVariant { person, company, academy }

enum WdsAvatarSize { xsmall, small, medium, large, xlarge }

/// User / entity avatar. Falls back through [imageProvider] → [initials] →
/// variant-default icon.
class WdsAvatar extends StatelessWidget {
  const WdsAvatar({
    super.key,
    this.variant = WdsAvatarVariant.person,
    this.size = WdsAvatarSize.medium,
    this.diameter,
    this.imageProvider,
    this.initials,
    this.semanticLabel,
  });

  final WdsAvatarVariant variant;
  final WdsAvatarSize size;

  /// Override the size step with an explicit pixel diameter.
  final double? diameter;

  final ImageProvider? imageProvider;
  final String? initials;
  final String? semanticLabel;

  double get _diameter =>
      diameter ??
      switch (size) {
        WdsAvatarSize.xsmall => 20,
        WdsAvatarSize.small => 28,
        WdsAvatarSize.medium => 40,
        WdsAvatarSize.large => 64,
        WdsAvatarSize.xlarge => 96,
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    final isPerson = variant == WdsAvatarVariant.person;
    final radius = isPerson ? _diameter / 2 : 8.0;
    final bg = isPerson ? colors.fillNormal : WdsColors.coolNeutral95;
    final fg = colors.labelAlternative;

    Widget content;
    if (imageProvider != null) {
      content = Image(image: imageProvider!, fit: BoxFit.cover);
    } else if (initials != null && initials!.isNotEmpty) {
      content = Center(
        child: Text(
          initials!,
          style: TextStyle(
            color: fg,
            fontSize: _diameter * 0.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    } else {
      content = Center(
        child: Icon(
          switch (variant) {
            WdsAvatarVariant.person => Icons.person,
            WdsAvatarVariant.company => Icons.apartment,
            WdsAvatarVariant.academy => Icons.school,
          },
          size: _diameter * 0.55,
          color: fg,
        ),
      );
    }

    return Semantics(
      image: imageProvider != null,
      label: semanticLabel,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Container(
          width: _diameter,
          height: _diameter,
          color: bg,
          child: content,
        ),
      ),
    );
  }
}
