import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/cache/signed_url_cache_provider.dart';
import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';
import '../../../calendar/presentation/providers/month_pieces_provider.dart';
import '../../../my_pieces/presentation/providers/my_pieces_feed_provider.dart';
import '../../../search/presentation/providers/search_providers.dart';
import 'action_tile.dart';
import '../providers/piece_by_id_provider.dart';

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

/// Read-only Piece detail. Photo + caption + meta + Edit / Delete tiles.
/// Edit pushes `.../:id/edit` (separate screen). Delete confirms
/// in-place.
class DetailScaffold extends ConsumerStatefulWidget {
  const DetailScaffold({super.key, required this.piece});

  final Piece piece;

  @override
  ConsumerState<DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends ConsumerState<DetailScaffold> {
  late Future<String> _signedUrl;
  bool _busy = false;

  @override
  void initState() {
    super.initState();

    _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
  }

  @override
  void didUpdateWidget(DetailScaffold old) {
    super.didUpdateWidget(old);

    if (old.piece.photoPath != widget.piece.photoPath) {
      _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
    }
  }

  // Inline error UI is gone — transport failures go through WdsSnackbar.

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this piece?'),
        content: const Text("This can't be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _busy = true);

    try {
      await ref
          .read(pieceRepositoryProvider)
          .delete(id: widget.piece.id, photoPath: widget.piece.photoPath);

      final d = widget.piece.date;
      ref.read(signedUrlCacheProvider).invalidate(widget.piece.photoPath);
      ref.invalidate(pieceByIdProvider(widget.piece.id));
      ref.invalidate(myPiecesFeedProvider);
      ref.invalidate(pieceMonthsProvider);
      ref.invalidate(searchResultsProvider);
      ref.invalidate(monthPiecesProvider(year: d.year, month: d.month));

      if (mounted) context.go('/my-pieces');
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        WdsSnackbar.show(
          context: context,
          message: 'Delete failed. Please try again.',
          variant: WdsSnackbarVariant.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final d = widget.piece.date;
    final dateLabel = '${_months[d.month - 1]} ${d.day}, ${d.year}';

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left),
          tooltip: 'Back',
        ),
        title: const Text('Piece'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.componentXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ColoredBox(
                    color: colors.backgroundNormalAlternative,
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
              ),
              SizedBox(height: spacing.componentLg),
              WdsText(widget.piece.comment, style: WdsTextStyle.heading1),
              SizedBox(height: spacing.componentSm),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: colors.labelAlternative,
                  ),
                  const SizedBox(width: 6),
                  WdsText(
                    dateLabel,
                    style: WdsTextStyle.caption1,
                    color: WdsTextColor.alternative,
                  ),
                ],
              ),
              SizedBox(height: spacing.componentXl),
              ActionTile(
                label: 'Edit Piece',
                icon: Icons.edit_outlined,
                tone: ActionTone.primary,
                disabled: _busy,
                onTap: () => context.push('/piece/${widget.piece.id}/edit'),
              ),
              SizedBox(height: spacing.componentSm),
              ActionTile(
                label: 'Delete Piece',
                icon: Icons.delete_outline,
                tone: ActionTone.negative,
                disabled: _busy,
                onTap: _confirmDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
