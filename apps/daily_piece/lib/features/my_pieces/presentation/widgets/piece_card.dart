import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/cache/signed_url_cache_provider.dart';
import '../../../../core/domain/entities/piece.dart';

const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// Full-width Piece card for the My Pieces feed — square photo on top,
/// caption (2 lines) + short date below. Signed URL goes through the shared
/// cache so re-mounting (scroll / tab switch) reuses the same URL within
/// its 1h TTL.
class PieceCard extends ConsumerStatefulWidget {
  const PieceCard({super.key, required this.piece, this.onTap});

  final Piece piece;
  final VoidCallback? onTap;

  @override
  ConsumerState<PieceCard> createState() => _PieceCardState();
}

class _PieceCardState extends ConsumerState<PieceCard> {
  late Future<String> _signedUrl;

  @override
  void initState() {
    super.initState();

    _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
  }

  @override
  void didUpdateWidget(PieceCard old) {
    super.didUpdateWidget(old);

    if (old.piece.photoPath != widget.piece.photoPath) {
      _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final d = widget.piece.date;
    final dateLabel = '${_months[d.month - 1]} ${d.day}, ${d.year}';

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ColoredBox(
          color: colors.backgroundElevatedNormal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1,
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
              Padding(
                padding: EdgeInsets.all(spacing.componentMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WdsText(
                      widget.piece.comment,
                      style: WdsTextStyle.body1,
                      maxLines: 2,
                    ),
                    SizedBox(height: spacing.componentSm),
                    WdsText(
                      dateLabel,
                      style: WdsTextStyle.caption1,
                      color: WdsTextColor.alternative,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
