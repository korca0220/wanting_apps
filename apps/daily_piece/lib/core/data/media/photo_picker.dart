import 'dart:typed_data';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'media_pipeline.dart';

/// Shows a "camera vs gallery" chooser, drives `image_picker`, then runs the
/// ADR 0004 compression pipeline. Returns upload-ready bytes, or `null` if
/// the user cancelled at either step (sheet dismiss / picker cancel).
///
/// Errors from compression / picker propagate as exceptions — the caller
/// owns the error UI.
Future<Uint8List?> pickAndProcessPhoto(BuildContext context) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    builder: (ctx) {
      final colors = ctx.wdsColors;

      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(
                Icons.camera_alt_outlined,
                color: colors.labelNormal,
              ),
              title: const Text('사진 찍기'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.camera),
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: colors.labelNormal,
              ),
              title: const Text('갤러리에서 고르기'),
              onTap: () => Navigator.of(ctx).pop(ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );

  if (source == null) return null;

  final picked = await ImagePicker().pickImage(source: source);
  if (picked == null) return null;

  return processForUpload(picked.path);
}
