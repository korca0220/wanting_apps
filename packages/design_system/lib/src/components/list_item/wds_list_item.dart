import 'package:flutter/material.dart';

import '../../foundations/wds_spacing.dart';
import '../../foundations/wds_typography_tokens.dart';
import '../../theme/wds_theme_ext.dart';

/// Single row in a list — `docs/components/24-list-item.md`.
///
/// Three slots: leading + content + trailing. Tap behaviour is wired
/// through [onTap]; trailing controls (e.g., Switch) handle their own
/// gestures and won't bubble up.
class WdsListItem extends StatelessWidget {
  const WdsListItem({
    super.key,
    this.leading,
    this.content,
    this.trailing,
    this.onTap,
    this.dense = false,
    this.selected = false,
    this.disabled = false,
  });

  final Widget? leading;
  final Widget? content;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool dense;
  final bool selected;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    final padding = dense
        ? const EdgeInsets.symmetric(
            horizontal: WdsSpacing.s12, vertical: WdsSpacing.s8)
        : const EdgeInsets.symmetric(
            horizontal: WdsSpacing.s16, vertical: WdsSpacing.s12);

    final minHeight = dense ? 48.0 : 56.0;

    Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[
          Opacity(
            opacity: disabled ? 0.4 : 1,
            child: leading,
          ),
          const SizedBox(width: WdsSpacing.s12),
        ],
        Expanded(
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: disabled ? colors.labelDisable : colors.labelNormal,
            ),
            child: content ?? const SizedBox.shrink(),
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: WdsSpacing.s12),
          Opacity(
            opacity: disabled ? 0.4 : 1,
            child: trailing,
          ),
        ],
      ],
    );

    final background = selected ? colors.primarySubtle : Colors.transparent;
    final selectedBorder = selected
        ? Border(
            left: BorderSide(color: colors.primaryNormal, width: 4),
          )
        : null;

    final body = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: selectedBorder,
        ),
        child: Padding(padding: padding, child: row),
      ),
    );

    if (onTap == null || disabled) return body;

    return Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(onTap: onTap, child: body),
      ),
    );
  }
}

/// Vertically stacks a title + optional caption, gap = 2px per spec.
class WdsListItemContent extends StatelessWidget {
  const WdsListItemContent({super.key, required this.title, this.caption});

  final Widget title;
  final Widget? caption;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        title,
        if (caption != null) ...[
          const SizedBox(height: WdsSpacing.s2),
          caption!,
        ],
      ],
    );
  }
}

/// Default Title typography — `text/body1 × regular`, label/normal color.
class WdsListItemTitle extends StatelessWidget {
  const WdsListItemTitle(this.text, {super.key, this.maxLines = 1});

  final String text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    return Text(
      text,
      style: WdsTypographyTokens.body1.copyWith(color: colors.labelNormal),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Default Caption typography — `text/label2`, label/alternative color.
class WdsListItemCaption extends StatelessWidget {
  const WdsListItemCaption(this.text, {super.key, this.maxLines = 1});

  final String text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    return Text(
      text,
      style: WdsTypographyTokens.label2.copyWith(color: colors.labelAlternative),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }
}
