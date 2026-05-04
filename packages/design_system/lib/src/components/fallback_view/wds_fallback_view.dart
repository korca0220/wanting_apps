import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

enum WdsFallbackViewPlatform { desktop, mobile }

enum WdsFallbackViewPadding { normal, compact }

/// Empty / error / fallback state. Composable image + title + description
/// + optional action.
class WdsFallbackView extends StatelessWidget {
  const WdsFallbackView({
    super.key,
    required this.title,
    this.description,
    this.image,
    this.action,
    this.platform = WdsFallbackViewPlatform.mobile,
    this.padding = WdsFallbackViewPadding.normal,
  });

  final String title;
  final String? description;

  /// Optional illustration / icon. Sized per [platform] (120 desktop / 88
  /// mobile) when supplied.
  final Widget? image;

  /// Optional action — typically a [WdsButton].
  final Widget? action;

  final WdsFallbackViewPlatform platform;
  final WdsFallbackViewPadding padding;

  double get _imageSize =>
      platform == WdsFallbackViewPlatform.desktop ? 120 : 88;

  EdgeInsets get _outerPadding => padding == WdsFallbackViewPadding.normal
      ? const EdgeInsets.all(40)
      : const EdgeInsets.all(24);

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;

    return Padding(
      padding: _outerPadding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (image != null) ...[
              SizedBox(
                width: _imageSize,
                height: _imageSize,
                child: image,
              ),
              const SizedBox(height: 16),
            ],
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                children: [
                  Text(
                    title,
                    style: type.heading2.copyWith(fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      description!,
                      style: type.body2.copyWith(
                        color: colors.labelAlternative,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
