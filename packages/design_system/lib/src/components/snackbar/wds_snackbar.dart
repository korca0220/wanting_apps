import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

enum WdsSnackbarVariant { info, success, warning, error }

/// Transient feedback strip with optional action.
///
/// Imperative API only — render via [WdsSnackbar.show]. Lifecycle is
/// managed by Flutter's `ScaffoldMessenger`.
class WdsSnackbar {
  WdsSnackbar._();

  /// Show a snackbar. Requires a [Scaffold] ancestor in [context].
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason> show({
    required BuildContext context,
    required String message,
    WdsSnackbarVariant variant = WdsSnackbarVariant.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final colors = context.wdsColors;
    final type = context.wdsType;
    final radii = context.wdsRadius;

    final iconData = switch (variant) {
      WdsSnackbarVariant.info => Icons.info_outline,
      WdsSnackbarVariant.success => Icons.check_circle_outline,
      WdsSnackbarVariant.warning => Icons.warning_amber_outlined,
      WdsSnackbarVariant.error => Icons.error_outline,
    };

    final iconColor = switch (variant) {
      WdsSnackbarVariant.info => colors.inverseLabel,
      WdsSnackbarVariant.success => colors.statusPositive,
      WdsSnackbarVariant.warning => colors.statusCautionary,
      WdsSnackbarVariant.error => colors.statusNegative,
    };

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colors.inverseBackground,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radii.card),
        ),
        duration: duration,
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                style: type.label1.copyWith(color: colors.inverseLabel),
              ),
            ),
          ],
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: colors.inversePrimary,
                onPressed: onAction,
              )
            : null,
      ),
    );
  }
}
