import 'package:flutter/material.dart';

import '../../foundations/wds_radius.dart';
import '../../foundations/wds_spacing.dart';
import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_theme_ext.dart';

enum WdsImageUploaderAspect { square, fourThree, sixteenNine, free }

enum WdsImageUploaderSize { small, medium, large }

/// Composable image upload slot — `docs/components/27-image-uploader.md`.
///
/// Stateless visual; wire OS picker via [onTap] (called when empty) and
/// [onReplace]/[onRemove] (called from preview mode).
class WdsImageUploader extends StatelessWidget {
  const WdsImageUploader({
    super.key,
    this.image,
    this.onTap,
    this.onRemove,
    this.aspect = WdsImageUploaderAspect.square,
    this.size = WdsImageUploaderSize.medium,
    this.disabled = false,
    this.loading = false,
    this.error,
    this.hint = 'Tap to select a photo',
    this.subhint,
    this.icon,
    this.imageFit = BoxFit.cover,
    this.semanticLabel = 'Select image',
    this.removeSemanticLabel = 'Remove image',
  });

  /// When non-null, render preview mode.
  final ImageProvider? image;

  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  final WdsImageUploaderAspect aspect;
  final WdsImageUploaderSize size;

  final bool disabled;
  final bool loading;

  /// Inline error text. Non-null switches the border to error tint.
  final String? error;

  final String hint;
  final String? subhint;

  /// Empty-mode icon. Defaults to camera.
  final IconData? icon;

  final BoxFit imageFit;

  final String semanticLabel;
  final String removeSemanticLabel;

  double? get _aspectRatio {
    switch (aspect) {
      case WdsImageUploaderAspect.square:
        return 1;
      case WdsImageUploaderAspect.fourThree:
        return 4 / 3;
      case WdsImageUploaderAspect.sixteenNine:
        return 16 / 9;
      case WdsImageUploaderAspect.free:
        return null;
    }
  }

  double get _minHeight {
    switch (size) {
      case WdsImageUploaderSize.small:
        return 120;
      case WdsImageUploaderSize.medium:
        return 160;
      case WdsImageUploaderSize.large:
        return 220;
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = ConstrainedBox(
      constraints: BoxConstraints(minHeight: _minHeight),
      child: _aspectRatio != null
          ? AspectRatio(aspectRatio: _aspectRatio!, child: _content(context))
          : _content(context),
    );

    if (error == null) return Opacity(opacity: disabled ? 0.4 : 1, child: body);

    final colors = context.wdsColors;
    return Opacity(
      opacity: disabled ? 0.4 : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          body,
          const SizedBox(height: WdsSpacing.s6),
          Text(
            error!,
            style: WdsTypographyTokens.caption1.copyWith(
              color: colors.statusNegative,
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(BuildContext context) {
    return image == null ? _empty(context) : _preview(context);
  }

  Widget _empty(BuildContext context) {
    final colors = context.wdsColors;
    final hasError = error != null;
    final borderColor = hasError
        ? colors.statusNegative
        : colors.lineNormalNeutral;

    final iconWidget = Icon(
      icon ?? Icons.camera_alt_outlined,
      size: 36,
      color: colors.labelAlternative,
    );

    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: !disabled && onTap != null,
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        behavior: HitTestBehavior.opaque,
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: borderColor,
            radius: WdsRadius.lg,
            strokeWidth: 2,
            dash: 6,
            gap: 4,
          ),
          child: ClipRRect(
            borderRadius: WdsRadius.brLg,
            child: Container(
              color: colors.fillAlternative,
              padding: const EdgeInsets.all(WdsSpacing.s16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconWidget,
                  const SizedBox(height: WdsSpacing.s8),
                  Text(
                    hint,
                    textAlign: TextAlign.center,
                    style: WdsTypographyTokens.body1.copyWith(
                      color: colors.labelNormal,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subhint != null) ...[
                    const SizedBox(height: WdsSpacing.s2),
                    Text(
                      subhint!,
                      textAlign: TextAlign.center,
                      style: WdsTypographyTokens.body2.copyWith(
                        color: colors.labelAlternative,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _preview(BuildContext context) {
    final colors = context.wdsColors;
    final children = <Widget>[
      Positioned.fill(
        child: ClipRRect(
          borderRadius: WdsRadius.brLg,
          child: Container(
            color: colors.fillAlternative,
            child: Image(image: image!, fit: imageFit),
          ),
        ),
      ),
      if (loading)
        Positioned.fill(
          child: ClipRRect(
            borderRadius: WdsRadius.brLg,
            child: ColoredBox(
              color: colors.materialDimmer,
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(colors.staticWhite),
                ),
              ),
            ),
          ),
        ),
      if (onRemove != null && !disabled)
        Positioned(
          top: WdsSpacing.s8,
          right: WdsSpacing.s8,
          child: _RemoveButton(onTap: onRemove!, label: removeSemanticLabel),
        ),
    ];

    return Stack(children: children);
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({required this.onTap, required this.label});

  final VoidCallback onTap;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    return Semantics(
      button: true,
      label: label,
      child: Material(
        color: colors.inverseBackground.withValues(alpha: 0.72),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: 28,
            height: 28,
            child: Icon(Icons.close, size: 16, color: colors.staticWhite),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
    required this.dash,
    required this.gap,
  });

  final Color color;
  final double radius;
  final double strokeWidth;
  final double dash;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    final dashed = _dashPath(path, dash: dash, gap: gap);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawPath(dashed, paint);
  }

  Path _dashPath(Path source, {required double dash, required double gap}) {
    final result = Path();
    for (final metric in source.computeMetrics()) {
      var distance = 0.0;
      var draw = true;
      while (distance < metric.length) {
        final length = draw ? dash : gap;
        if (draw) {
          result.addPath(
            metric.extractPath(distance, distance + length),
            Offset.zero,
          );
        }
        distance += length;
        draw = !draw;
      }
    }
    return result;
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) =>
      old.color != color ||
      old.radius != radius ||
      old.strokeWidth != strokeWidth ||
      old.dash != dash ||
      old.gap != gap;
}
