import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

/// Form-field label. Polymorphic in typography — pass any [TextStyle] via
/// [style], otherwise defaults to `text/label1` × `labelNormal`.
class WdsLabel extends StatelessWidget {
  const WdsLabel({
    super.key,
    required this.text,
    this.required = false,
    this.disabled = false,
    this.style,
  });

  final String text;
  final bool required;
  final bool disabled;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;

    final base = (style ?? type.label1).copyWith(
      color: disabled ? colors.labelDisable : null,
    );

    return Text.rich(
      TextSpan(
        text: text,
        style: base,
        children: [
          if (required)
            TextSpan(
              text: ' *',
              style: base.copyWith(color: colors.statusNegative),
            ),
        ],
      ),
    );
  }
}
