import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

enum WdsModalSize { small, medium, large, xlarge }

/// Modal container — popup (centred), bottom sheet, or fullscreen variants.
///
/// Imperative API. Returns the value passed to `Navigator.pop` from inside
/// the modal builder.
class WdsModal {
  WdsModal._();

  /// Centred popup (Material `showDialog` underneath).
  static Future<T?> showPopup<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    WdsModalSize size = WdsModalSize.medium,
    bool barrierDismissible = true,
    bool useEscape = true,
  }) {
    final colors = context.wdsColors;
    final radii = context.wdsRadius;
    final shadows = context.wdsShadows;

    final maxWidth = switch (size) {
      WdsModalSize.small => 400.0,
      WdsModalSize.medium => 560.0,
      WdsModalSize.large => 720.0,
      WdsModalSize.xlarge => 960.0,
    };

    return showDialog<T>(
      context: context,
      barrierColor: colors.materialDimmer,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            decoration: BoxDecoration(
              color: colors.backgroundElevatedNormal,
              borderRadius: BorderRadius.circular(radii.modal),
              boxShadow: shadows.normalLarge,
            ),
            clipBehavior: Clip.antiAlias,
            child: builder(ctx),
          ),
        ),
      ),
    );
  }

  /// Bottom sheet variant. Uses Material `showModalBottomSheet`.
  static Future<T?> showBottom<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
  }) {
    final colors = context.wdsColors;
    final radii = context.wdsRadius;

    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: colors.backgroundElevatedNormal,
      barrierColor: colors.materialDimmer,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(radii.modalLarge),
        ),
      ),
      builder: (ctx) => SafeArea(child: builder(ctx)),
    );
  }

  /// Fullscreen variant. Pushes a fullscreen route.
  static Future<T?> showFull<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,
  }) {
    return Navigator.of(
      context,
    ).push<T>(MaterialPageRoute<T>(fullscreenDialog: true, builder: builder));
  }
}

/// Top navigation bar for modals — title + close button.
class WdsModalNavigation extends StatelessWidget {
  const WdsModalNavigation({super.key, required this.title, this.onClose});

  final String title;

  /// Defaults to `Navigator.of(context).pop()` when null.
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final type = context.wdsType;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: type.title3.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: onClose ?? () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

/// Padded body region.
class WdsModalContent extends StatelessWidget {
  const WdsModalContent({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: child,
    );
  }
}

/// Right-aligned action button strip pinned to the bottom of the modal.
class WdsModalActionArea extends StatelessWidget {
  const WdsModalActionArea({super.key, required this.actions});

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (var i = 0; i < actions.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            actions[i],
          ],
        ],
      ),
    );
  }
}
