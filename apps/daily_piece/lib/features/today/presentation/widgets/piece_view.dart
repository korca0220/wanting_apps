import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/cache/signed_url_cache_provider.dart';
import '../../../../core/domain/entities/piece.dart';

/// View mode — today's Piece already saved. Read-only for now (edit/delete is
/// a follow-up flow).
class PieceView extends ConsumerStatefulWidget {
  const PieceView({super.key, required this.piece});
  final Piece piece;

  @override
  ConsumerState<PieceView> createState() => _PieceViewState();
}

class _PieceViewState extends ConsumerState<PieceView> {
  late Future<String> _signedUrl;

  @override
  void initState() {
    super.initState();

    _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
  }

  @override
  void didUpdateWidget(PieceView old) {
    super.didUpdateWidget(old);

    // Provider invalidation pushes a fresh Piece in (e.g. after photo
    // replace from the detail screen) — re-resolve the signed URL so the
    // FutureBuilder doesn't keep showing the previous path's bytes.
    if (old.piece.photoPath != widget.piece.photoPath) {
      _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;

    return Padding(
      padding: EdgeInsets.all(spacing.componentXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: FutureBuilder<String>(
                future: _signedUrl,
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(child: WdsSpinner());
                  }
                  return Image.network(snap.data!, fit: BoxFit.cover);
                },
              ),
            ),
          ),
          SizedBox(height: spacing.componentLg),
          WdsText(widget.piece.comment, style: WdsTextStyle.headline2),
          SizedBox(height: spacing.componentSm),
          const WdsText(
            '오늘의 Piece는 이미 저장됐어요.',
            style: WdsTextStyle.body2,
            color: WdsTextColor.alternative,
          ),
        ],
      ),
    );
  }
}
