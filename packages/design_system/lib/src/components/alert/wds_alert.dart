import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';
import '../button/wds_button.dart';

enum WdsAlertActionVariant { normal, assistive, negative }

/// Confirmation/warning dialog. Use [WdsAlert.show] to display modally.
///
/// Per `docs/components/18-alert.md`, Alert is **always modal** with focus
/// trap and a backdrop dimmer. Inline messaging belongs in `Snackbar` or a
/// future `SectionMessage` component.
class WdsAlert extends StatelessWidget {
  const WdsAlert({
    super.key,
    required this.title,
    required this.actions,
    this.description,
  });

  final String title;
  final String? description;
  final List<WdsAlertAction> actions;

  /// Imperative entry. Returns the value supplied via `Navigator.pop`
  /// from the chosen action.
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required List<WdsAlertAction> actions,
    String? description,
    bool barrierDismissible = true,
  }) {
    final dimmer = context.wdsColors.materialDimmer;
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: dimmer,
      builder: (_) => WdsAlert(
        title: title,
        description: description,
        actions: actions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;
    final radii = context.wdsRadius;
    final shadows = context.wdsShadows;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Container(
          decoration: BoxDecoration(
            color: colors.backgroundElevatedNormal,
            borderRadius: BorderRadius.circular(radii.modal),
            boxShadow: shadows.normalLarge,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: type.title3.copyWith(fontWeight: FontWeight.w700),
              ),
              if (description != null) ...[
                const SizedBox(height: 8),
                Text(description!, style: type.body2),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (var i = 0; i < actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: 8),
                    actions[i],
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Single action in a [WdsAlert]. Negative variant tints the button with
/// `status/negative` to flag destructive intent.
class WdsAlertAction extends StatelessWidget {
  const WdsAlertAction({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = WdsAlertActionVariant.normal,
  });

  final String label;
  final VoidCallback onPressed;
  final WdsAlertActionVariant variant;

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case WdsAlertActionVariant.normal:
        return WdsButton(
          onPressed: onPressed,
          variant: WdsButtonVariant.solid,
          color: WdsButtonColor.primary,
          size: WdsButtonSize.small,
          child: Text(label),
        );
      case WdsAlertActionVariant.assistive:
        return WdsButton(
          onPressed: onPressed,
          variant: WdsButtonVariant.outlined,
          color: WdsButtonColor.assistive,
          size: WdsButtonSize.small,
          child: Text(label),
        );
      case WdsAlertActionVariant.negative:
        return _NegativeAlertAction(label: label, onPressed: onPressed);
    }
  }
}

class _NegativeAlertAction extends StatelessWidget {
  const _NegativeAlertAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: colors.statusNegative,
        foregroundColor: colors.staticWhite,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(label),
    );
  }
}
