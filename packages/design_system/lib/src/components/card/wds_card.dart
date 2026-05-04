import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

/// Composable card container.
///
/// Per `docs/components/06-card.md`, Card is intentionally non-interactive
/// — wrap with [InkWell]/[GestureDetector] for tap behaviour. Hover-lift
/// is left to consumers since Flutter's hover surface depends on the
/// platform.
class WdsCard extends StatelessWidget {
  const WdsCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.outlined = false,
    this.elevation = WdsCardElevation.small,
  });

  final Widget child;
  final EdgeInsets padding;
  final bool outlined;
  final WdsCardElevation elevation;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final radii = context.wdsRadius;
    final shadows = context.wdsShadows;

    final shadowList = switch (elevation) {
      WdsCardElevation.none => const <BoxShadow>[],
      WdsCardElevation.small => shadows.normalSmall,
      WdsCardElevation.medium => shadows.normalMedium,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(radii.card),
        boxShadow: shadowList,
        border: outlined
            ? Border.all(color: colors.lineNormalAlternative, width: 1)
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radii.card),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

enum WdsCardElevation { none, small, medium }

/// Card thumbnail / cover image area. Supports leading + trailing overlays
/// stacked over the thumbnail.
class WdsCardThumbnail extends StatelessWidget {
  const WdsCardThumbnail({
    super.key,
    required this.child,
    this.aspectRatio,
    this.leadingOverlay,
    this.trailingOverlay,
  });

  final Widget child;
  final double? aspectRatio;
  final Widget? leadingOverlay;
  final Widget? trailingOverlay;

  @override
  Widget build(BuildContext context) {
    final radii = context.wdsRadius;
    Widget content = ClipRRect(
      borderRadius: BorderRadius.circular(radii.thumbnail),
      child: child,
    );
    if (aspectRatio != null) {
      content = AspectRatio(aspectRatio: aspectRatio!, child: content);
    }

    if (leadingOverlay == null && trailingOverlay == null) {
      return content;
    }

    return Stack(
      children: [
        content,
        if (leadingOverlay != null)
          Positioned(top: 8, left: 8, child: leadingOverlay!),
        if (trailingOverlay != null)
          Positioned(top: 8, right: 8, child: trailingOverlay!),
      ],
    );
  }
}

/// Card title — Typography wrapper. Defaults to `text/headline2 × bold`.
class WdsCardTitle extends StatelessWidget {
  const WdsCardTitle(this.text, {super.key, this.style, this.maxLines = 2});

  final String text;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final type = context.wdsType;
    return Text(
      text,
      style: style ?? type.headline2.copyWith(fontWeight: FontWeight.w700),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Card caption — Typography wrapper. Defaults to `text/body2`.
class WdsCardCaption extends StatelessWidget {
  const WdsCardCaption(this.text, {super.key, this.style, this.maxLines = 2});

  final String text;
  final TextStyle? style;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;
    return Text(
      text,
      style: style ??
          type.body2.copyWith(color: colors.labelAlternative),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Vertical content stack with token-driven spacing.
class WdsCardContent extends StatelessWidget {
  const WdsCardContent({
    super.key,
    required this.children,
    this.gap = 8,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  final List<Widget> children;
  final double gap;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          children[i],
        ],
      ],
    );
  }
}
