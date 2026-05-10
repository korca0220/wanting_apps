import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/cache/signed_url_cache_provider.dart';
import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';
import '../../../collection/presentation/providers/collection_feed_provider.dart';
import '../../../today/presentation/providers/today_piece_provider.dart';
import '../providers/piece_by_id_provider.dart';

/// Owns the full scaffold once a Piece is loaded — AppBar actions(edit/delete)
/// + inline edit mode for the comment + signed URL fetch for the photo.
class DetailScaffold extends ConsumerStatefulWidget {
  const DetailScaffold({super.key, required this.piece});

  final Piece piece;

  @override
  ConsumerState<DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends ConsumerState<DetailScaffold> {
  late Future<String> _signedUrl;
  late TextEditingController _commentCtrl;

  bool _editing = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
    _commentCtrl = TextEditingController(text: widget.piece.comment);
  }

  @override
  void didUpdateWidget(DetailScaffold old) {
    super.didUpdateWidget(old);

    // Provider invalidation pushes a fresh Piece in — sync the controller so
    // a subsequent edit starts from the latest comment, not the stale one.
    if (!_editing && old.piece.comment != widget.piece.comment) {
      _commentCtrl.text = widget.piece.comment;
    }
  }

  @override
  void dispose() {
    _commentCtrl.dispose();

    super.dispose();
  }

  void _startEdit() {
    setState(() {
      _editing = true;
      _error = null;
      _commentCtrl.text = widget.piece.comment;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editing = false;
      _error = null;
    });
  }

  Future<void> _saveEdit() async {
    final next = _commentCtrl.text.trim();
    if (next.isEmpty) {
      setState(() => _error = '코멘트를 입력해주세요.');
      return;
    }
    if (next.length > Piece.commentMaxLength) {
      setState(() => _error = '코멘트는 ${Piece.commentMaxLength}자 이하여야 해요.');
      return;
    }
    if (next == widget.piece.comment) {
      _cancelEdit();
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref
          .read(pieceRepositoryProvider)
          .updateComment(id: widget.piece.id, comment: next);

      _invalidatePieceCaches();

      if (mounted) {
        setState(() {
          _editing = false;
          _busy = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '저장에 실패했어요: $e';
          _busy = false;
        });
      }
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Piece를 삭제할까요?'),
        content: const Text('한 번 지우면 되돌릴 수 없어요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref
          .read(pieceRepositoryProvider)
          .delete(id: widget.piece.id, photoPath: widget.piece.photoPath);

      ref.read(signedUrlCacheProvider).invalidate(widget.piece.photoPath);
      _invalidatePieceCaches();

      if (mounted) context.go('/collection');
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '삭제에 실패했어요: $e';
          _busy = false;
        });
      }
    }
  }

  /// Fanout to the three providers that may be holding this Piece — by-id,
  /// the timeline feed, and Today (if this Piece happens to be today's).
  /// Cheap to over-invalidate; the alternative is per-call branching that
  /// drifts as new screens land.
  void _invalidatePieceCaches() {
    ref.invalidate(pieceByIdProvider(widget.piece.id));
    ref.invalidate(collectionFeedProvider);
    ref.invalidate(todayPieceProvider);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final d = widget.piece.date;
    final dateLabel =
        '${d.year.toString().padLeft(4, '0')}. ${d.month.toString().padLeft(2, '0')}. ${d.day.toString().padLeft(2, '0')}';

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        actions: _editing
            ? [
                TextButton(
                  onPressed: _busy ? null : _cancelEdit,
                  child: const Text('취소'),
                ),
                TextButton(
                  onPressed: _busy ? null : _saveEdit,
                  child: const Text('저장'),
                ),
              ]
            : [
                IconButton(
                  onPressed: _busy ? null : _startEdit,
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: '수정',
                ),
                IconButton(
                  onPressed: _busy ? null : _confirmDelete,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: '삭제',
                ),
              ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: spacing.componentXl),
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
              if (_editing)
                WdsTextField(
                  controller: _commentCtrl,
                  label: '코멘트',
                  placeholder: '오늘을 한 줄로 (최대 ${Piece.commentMaxLength}자)',
                  disabled: _busy,
                  errorText: _error,
                  invalid: _error != null,
                )
              else
                WdsText(widget.piece.comment, style: WdsTextStyle.headline2),
              SizedBox(height: spacing.componentSm),
              WdsText(
                dateLabel,
                style: WdsTextStyle.body2,
                color: WdsTextColor.alternative,
              ),
              if (!_editing && _error != null) ...[
                SizedBox(height: spacing.componentMd),
                WdsText(
                  _error!,
                  style: WdsTextStyle.body2,
                  color: WdsTextColor.alternative,
                ),
              ],
              SizedBox(height: spacing.componentXl),
            ],
          ),
        ),
      ),
    );
  }
}
