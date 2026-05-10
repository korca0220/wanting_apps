import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/cache/signed_url_cache_provider.dart';
import '../../../../core/domain/entities/piece.dart';

/// One tile in the timeline grid. Signed URL goes through the shared cache so
/// re-mounting the tile (scroll, tab switch) reuses the same URL within its
/// 1h TTL — that's what lets `Image.network` hit Flutter's ImageCache.
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

    _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
  }

  @override
  void didUpdateWidget(PieceThumbnail old) {
    super.didUpdateWidget(old);

    // Feed invalidation can swap the piece at this index (photo replace
    // creates a new path). Without this, the tile keeps rendering the old
    // signed URL because the Future was captured in initState.
    if (old.piece.photoPath != widget.piece.photoPath) {
      _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
    }
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
