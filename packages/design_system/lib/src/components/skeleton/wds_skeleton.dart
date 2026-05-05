import 'package:flutter/material.dart';

import '../../foundations/wds_radius.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsSkeletonVariant { text, circle, rectangle }

/// Loading placeholder with shimmer animation.
///
/// Per `docs/components/21-skeleton.md`: 1.5s ease-in-out infinite shimmer
/// gradient sweeping left → right. Reduced-motion collapses to a static
/// fill.
class WdsSkeleton extends StatefulWidget {
  const WdsSkeleton({
    super.key,
    this.variant = WdsSkeletonVariant.text,
    this.width,
    this.height,
    this.borderRadius,
  });

  final WdsSkeletonVariant variant;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  @override
  State<WdsSkeleton> createState() => _WdsSkeletonState();
}

class _WdsSkeletonState extends State<WdsSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final reduced = MediaQuery.maybeDisableAnimationsOf(context) ?? false;

    final width = widget.width ?? _defaultWidth;
    final height = widget.height ?? _defaultHeight;

    final radius = widget.borderRadius ?? _defaultRadius(width, height);

    final base = colors.fillNormal;
    final highlight = colors.fillAlternative;

    Widget content = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: base, borderRadius: radius),
    );

    if (!reduced) {
      content = AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) {
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: LinearGradient(
                colors: [base, highlight, base],
                stops: const [0.0, 0.5, 1.0],
                begin: Alignment(-1 + _ctrl.value * 4, 0),
                end: Alignment(1 + _ctrl.value * 4, 0),
              ),
            ),
          );
        },
      );
    }

    return Semantics(liveRegion: true, label: 'Loading', child: content);
  }

  double get _defaultWidth => switch (widget.variant) {
    WdsSkeletonVariant.text => 120,
    WdsSkeletonVariant.circle => 40,
    WdsSkeletonVariant.rectangle => 120,
  };

  double get _defaultHeight => switch (widget.variant) {
    WdsSkeletonVariant.text => 14,
    WdsSkeletonVariant.circle => 40,
    WdsSkeletonVariant.rectangle => 80,
  };

  BorderRadius _defaultRadius(double w, double h) {
    switch (widget.variant) {
      case WdsSkeletonVariant.text:
        return WdsRadius.brSm;
      case WdsSkeletonVariant.circle:
        return BorderRadius.circular(w.clamp(0, double.infinity));
      case WdsSkeletonVariant.rectangle:
        return WdsRadius.brMd;
    }
  }
}
