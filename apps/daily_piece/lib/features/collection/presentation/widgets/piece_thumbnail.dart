import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';

/// One tile in the timeline grid. Resolves a 1h signed URL on first build —
/// re-resolved each time the widget is created (cheap; bucket is private).
class PieceThumbnail extends ConsumerStatefulWidget {
  const PieceThumbnail({super.key, required this.piece, this.onTap});

  final Piece piece;
  final VoidCallback? onTap;

  @override
  ConsumerState<PieceThumbnail> createState() => _PieceThumbnailState();
}

class _PieceThumbnailState extends ConsumerState<PieceThumbnail> {
  late Future<String> _signedUrl;

  @override
  void initState() {
    super.initState();

    _signedUrl = ref
        .read(pieceRepositoryProvider)
        .signedPhotoUrl(widget.piece.photoPath);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return GestureDetector(
      onTap: widget.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ColoredBox(
          color: colors.backgroundNormalAlternative,
          child: FutureBuilder<String>(
            future: _signedUrl,
            builder: (context, snap) {
              if (!snap.hasData) {
                return const Center(child: WdsSpinner());
              }
              return Image.network(
                snap.data!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: colors.labelAlternative,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
