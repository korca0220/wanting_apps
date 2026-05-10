import 'dart:typed_data';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/data/cache/signed_url_cache_provider.dart';
import '../../../../core/data/media/media_pipeline.dart';
import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';
import '../../../collection/presentation/providers/collection_feed_provider.dart';
import '../../../today/presentation/providers/today_piece_provider.dart';
import '../providers/piece_by_id_provider.dart';

/// Owns the full scaffold once a Piece is loaded — AppBar actions(edit/delete)
/// + inline edit mode for both the comment and the photo + signed URL fetch
/// for the photo when not previewing a replacement.
class DetailScaffold extends ConsumerStatefulWidget {
  const DetailScaffold({super.key, required this.piece});

  final Piece piece;

  @override
  ConsumerState<DetailScaffold> createState() => _DetailScaffoldState();
}

class _DetailScaffoldState extends ConsumerState<DetailScaffold> {
  late Future<String> _signedUrl;
  late TextEditingController _commentCtrl;
  final _picker = ImagePicker();

  /// Locally-staged replacement photo. Non-null while in edit mode and the
  /// user has just picked a new image — committed on save.
  Uint8List? _pendingPhotoBytes;

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

    // Provider invalidation pushes a fresh Piece in — re-resolve the signed
    // URL for the new path and re-seed the comment controller so the next
    // edit starts from the latest state.
    if (old.piece.photoPath != widget.piece.photoPath) {
      _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
    }
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
      _pendingPhotoBytes = null;
      _commentCtrl.text = widget.piece.comment;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editing = false;
      _error = null;
      _pendingPhotoBytes = null;
    });
  }

  Future<void> _pickReplacementPhoto() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final picked = await _picker.pickImage(source: ImageSource.gallery);
      if (picked == null) {
        if (mounted) setState(() => _busy = false);
        return;
      }

      final bytes = await processForUpload(picked.path);
      if (!mounted) return;

      setState(() {
        _pendingPhotoBytes = bytes;
        _busy = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '사진 처리에 실패했어요: $e';
          _busy = false;
        });
      }
    }
  }

  Future<void> _saveEdit() async {
    final next = _commentCtrl.text.trim();
    if (next.isEmpty) {
      setState(() => _error = '코멘트를 입력해주세요.');
      return;
    }

    final commentChanged = next != widget.piece.comment;
    final photoChanged = _pendingPhotoBytes != null;
    if (!commentChanged && !photoChanged) {
      _cancelEdit();
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final repo = ref.read(pieceRepositoryProvider);

    try {
      // Photo first — it's the bigger / failure-prone operation. If it
      // throws, no DB write happened, so the comment isn't half-applied.
      if (photoChanged) {
        final oldPath = widget.piece.photoPath;

        await repo.replacePhoto(
          id: widget.piece.id,
          oldPhotoPath: oldPath,
          newPhotoBytes: _pendingPhotoBytes!,
        );

        ref.read(signedUrlCacheProvider).invalidate(oldPath);
      }
      if (commentChanged) {
        await repo.updateComment(id: widget.piece.id, comment: next);
      }

      _invalidatePieceCaches();

      if (mounted) {
        setState(() {
          _editing = false;
          _busy = false;
          _pendingPhotoBytes = null;
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
                child: GestureDetector(
                  onTap: (_editing && !_busy) ? _pickReplacementPhoto : null,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _pendingPhotoBytes != null
                            ? Image.memory(
                                _pendingPhotoBytes!,
                                fit: BoxFit.cover,
                              )
                            : FutureBuilder<String>(
                                future: _signedUrl,
                                builder: (context, snap) {
                                  if (!snap.hasData) {
                                    return const Center(child: WdsSpinner());
                                  }
                                  return Image.network(
                                    snap.data!,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                      ),
                      if (_editing)
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colors.backgroundElevatedNormal,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: WdsText(
                                _pendingPhotoBytes == null
                                    ? '탭해서 사진 교체'
                                    : '교체할 사진 선택됨',
                                style: WdsTextStyle.caption1,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacing.componentLg),
              if (_editing)
                WdsTextField(
                  controller: _commentCtrl,
                  label: '코멘트',
                  placeholder: '오늘을 한 줄로 (최대 ${Piece.commentMaxLength}자)',
                  maxLength: Piece.commentMaxLength,
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
