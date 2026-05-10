import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

/// ADR 0004 — long edge 1080px, JPEG q=80, EXIF stripped, pixel rotation
/// baked in. Returns the bytes ready to upload.
Future<Uint8List> processForUpload(String sourcePath) async {
  final out = await FlutterImageCompress.compressWithFile(
    sourcePath,
    minWidth: 1080,
    minHeight: 1080,
    quality: 80,
    keepExif: false,
    format: CompressFormat.jpeg,
  );
  if (out == null) {
    throw const FormatException('Image compression returned null');
  }
  return out;
}
