import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class PhotoPlaceholder extends StatelessWidget {
  const PhotoPlaceholder({super.key, required this.busy});

  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Container(
      color: colors.backgroundNormalAlternative,
      child: Center(
        child: busy
            ? const WdsSpinner()
            : const WdsText(
                '탭해서 사진 고르기',
                style: WdsTextStyle.body1,
                color: WdsTextColor.alternative,
              ),
      ),
    );
  }
}
