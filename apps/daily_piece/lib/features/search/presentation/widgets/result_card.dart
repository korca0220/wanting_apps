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

/// Horizontal result row — 80×80 thumbnail on the left, caption (2 lines)
/// + short date on the right.
class SearchResultCard extends ConsumerStatefulWidget {
  const SearchResultCard({super.key, required this.piece, required this.onTap});

  final Piece piece;
  final VoidCallback onTap;

  @override
  ConsumerState<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends ConsumerState<SearchResultCard> {
  late Future<String> _signedUrl;

  @override
  void initState() {
    super.initState();

    _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
  }

  @override
  void didUpdateWidget(SearchResultCard old) {
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

    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: colors.backgroundElevatedNormal,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.lineNormalNeutral, width: 1),
        ),
        padding: EdgeInsets.all(spacing.componentSm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 80,
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
            ),
            SizedBox(width: spacing.componentMd),
            Expanded(
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
    );
  }
}
