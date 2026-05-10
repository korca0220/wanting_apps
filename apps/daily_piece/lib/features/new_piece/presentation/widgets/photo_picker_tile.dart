import 'dart:typed_data';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Tappable bordered tile for selecting a photo. Renders a centered camera
/// icon + helper text when empty, or a preview image when populated.
class PhotoPickerTile extends StatelessWidget {
  const PhotoPickerTile({
    super.key,
    required this.bytes,
    required this.busy,
    required this.onTap,
  });

  final Uint8List? bytes;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final hasPhoto = bytes != null;

    return AspectRatio(
      aspectRatio: 1,
      child: GestureDetector(
        onTap: busy ? null : onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.backgroundElevatedAlternative,
            borderRadius: BorderRadius.circular(16),
            border: hasPhoto
                ? null
                : Border.all(color: colors.lineNormalNeutral, width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: hasPhoto
                ? Image.memory(bytes!, fit: BoxFit.cover)
                : Center(
                    child: Padding(
                      padding: EdgeInsets.all(spacing.componentXl),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (busy)
                            const WdsSpinner()
                          else
                            Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                              color: colors.labelAlternative,
                            ),
                          SizedBox(height: spacing.componentMd),
                          const WdsText(
                            'Tap to select a photo',
                            style: WdsTextStyle.body1,
                          ),
                          SizedBox(height: spacing.componentSm),
                          const WdsText(
                            'Share your moment of the day',
                            style: WdsTextStyle.caption1,
                            color: WdsTextColor.alternative,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
