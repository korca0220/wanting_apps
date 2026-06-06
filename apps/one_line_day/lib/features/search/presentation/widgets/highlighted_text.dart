import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({super.key, required this.text, required this.query});

  final String text;
  final String query;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final baseStyle = context.wdsType.body1.copyWith(color: colors.labelNormal);
    final highlightStyle = baseStyle.copyWith(
      color: colors.primaryNormal,
      fontWeight: FontWeight.w700,
    );

    final lower = text.toLowerCase();
    final lowerQ = query.toLowerCase();
    final idx = lower.indexOf(lowerQ);

    if (idx < 0) return Text(text, style: baseStyle);

    return Text.rich(
      TextSpan(
        children: [
          if (idx > 0) TextSpan(text: text.substring(0, idx), style: baseStyle),
          TextSpan(
            text: text.substring(idx, idx + query.length),
            style: highlightStyle,
          ),
          if (idx + query.length < text.length)
            TextSpan(
              text: text.substring(idx + query.length),
              style: baseStyle,
            ),
        ],
      ),
    );
  }
}
