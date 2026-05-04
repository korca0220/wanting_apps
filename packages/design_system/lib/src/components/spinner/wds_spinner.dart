import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundations/wds_colors.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsSpinnerVariant { circular, wanted }

/// Indeterminate progress indicator.
///
/// `circular` — single-colour rotating arc.
/// `wanted` — brand 4-colour cycle: blue/primary → cyan → violet → pink,
/// driven by a single AnimationController that both rotates the arc and
/// lerps between cycle stops. Uses Material's `CircularProgressIndicator`
/// repaint loop with a `ValueListenable` colour. Honours
/// `MediaQuery.disableAnimationsOf` (renders a static arc when reduced
/// motion is requested).
class WdsSpinner extends StatefulWidget {
  const WdsSpinner({
    super.key,
    this.variant = WdsSpinnerVariant.circular,
    this.size = 24,
    this.color,
    this.semanticLabel = 'Loading',
  });

  final WdsSpinnerVariant variant;
  final double size;
  final Color? color;
  final String semanticLabel;

  @override
  State<WdsSpinner> createState() => _WdsSpinnerState();
}

class _WdsSpinnerState extends State<WdsSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
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
    final stroke = (widget.size * 0.1).clamp(1.5, 4.0);
    final reduced = MediaQuery.disableAnimationsOf(context);

    if (widget.variant == WdsSpinnerVariant.circular) {
      final c = widget.color ?? colors.labelNormal;
      return Semantics(
        label: widget.semanticLabel,
        liveRegion: true,
        child: SizedBox(
          width: widget.size,
          height: widget.size,
          child: CircularProgressIndicator(
            strokeWidth: stroke,
            valueColor: AlwaysStoppedAnimation<Color>(c),
            value: reduced ? 0.25 : null,
          ),
        ),
      );
    }

    // wanted: 4-color cycle
    final cycle = <Color>[
      widget.color ?? colors.primaryNormal,
      WdsColors.cyan50,
      WdsColors.violet50,
      WdsColors.pink50,
    ];

    return Semantics(
      label: widget.semanticLabel,
      liveRegion: true,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (context, _) {
            final t = reduced ? 0.0 : _ctrl.value;
            // 4 stops, looping
            final scaled = t * cycle.length;
            final i = scaled.floor() % cycle.length;
            final j = (i + 1) % cycle.length;
            final f = scaled - scaled.floor();
            final color = Color.lerp(cycle[i], cycle[j], f)!;
            return Transform.rotate(
              angle: reduced ? 0 : t * 2 * math.pi,
              child: CircularProgressIndicator(
                strokeWidth: stroke,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                value: reduced ? 0.25 : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
