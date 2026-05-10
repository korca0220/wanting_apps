import 'dart:typed_data';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/cache/signed_url_cache_provider.dart';
import '../../../../core/data/media/photo_picker.dart';
import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';
import '../../../my_pieces/presentation/providers/my_pieces_feed_provider.dart';
import '../../../piece_detail/presentation/providers/piece_by_id_provider.dart';
import '../../../piece_detail/presentation/widgets/error_view.dart';
import '../../../piece_detail/presentation/widgets/missing_view.dart';

class EditPiecePage extends ConsumerWidget {
  const EditPiecePage({super.key, required this.pieceId});

  final String pieceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final piece = ref.watch(pieceByIdProvider(pieceId));

    return piece.when(
      loading: () => Scaffold(
        backgroundColor: colors.backgroundNormalNormal,
        appBar: AppBar(),
        body: const Center(child: WdsSpinner()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: colors.backgroundNormalNormal,
        appBar: AppBar(),
        body: SafeArea(
          child: ErrorView(
            error: e,
            onRetry: () => ref.invalidate(pieceByIdProvider(pieceId)),
          ),
        ),
      ),
      data: (p) => p == null
          ? Scaffold(
              backgroundColor: colors.backgroundNormalNormal,
              appBar: AppBar(),
              body: const SafeArea(child: MissingView()),
            )
          : _EditForm(piece: p),
    );
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const _EditForm({required this.piece});

  final Piece piece;

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  late TextEditingController _commentCtrl;
  late Future<String> _signedUrl;
  Uint8List? _pendingPhotoBytes;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    _commentCtrl = TextEditingController(text: widget.piece.comment);
    _commentCtrl.addListener(() => setState(() {}));
    _signedUrl = ref.read(signedUrlCacheProvider).get(widget.piece.photoPath);
  }

  @override
  void dispose() {
    _commentCtrl.dispose();

    super.dispose();
  }

  bool get _changed {
    final commentChanged = _commentCtrl.text.trim() != widget.piece.comment;
    final photoChanged = _pendingPhotoBytes != null;
    return (commentChanged || photoChanged) &&
        _commentCtrl.text.trim().isNotEmpty;
  }

  Future<void> _pickReplacementPhoto() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final bytes = await pickAndProcessPhoto(context);
      if (!mounted) return;

      setState(() {
        if (bytes != null) _pendingPhotoBytes = bytes;
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

  Future<void> _save() async {
    final next = _commentCtrl.text.trim();
    if (next.isEmpty) {
      setState(() => _error = '코멘트를 입력해주세요.');
      return;
    }

    final commentChanged = next != widget.piece.comment;
    final photoChanged = _pendingPhotoBytes != null;
    if (!commentChanged && !photoChanged) {
      context.pop();
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    final repo = ref.read(pieceRepositoryProvider);

    try {
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

      ref.invalidate(pieceByIdProvider(widget.piece.id));
      ref.invalidate(myPiecesFeedProvider);

      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '저장에 실패했어요: $e';
          _busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final length = _commentCtrl.text.length;
    final canSave = _changed && !_busy;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        leading: TextButton(
          onPressed: _busy ? null : () => context.pop(),
          child: const Text('Cancel'),
        ),
        leadingWidth: 80,
        title: const Text('Edit Piece'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: canSave ? _save : null,
            child: WdsText(
              'Save',
              style: WdsTextStyle.label1,
              color: canSave ? WdsTextColor.primary : WdsTextColor.disable,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.componentXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const WdsText('Photo', style: WdsTextStyle.heading1),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: colors.backgroundElevatedAlternative,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const WdsText(
                      'Required',
                      style: WdsTextStyle.caption1,
                      color: WdsTextColor.alternative,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.componentMd),
              AspectRatio(
                aspectRatio: 1,
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
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: WdsButton(
                        size: WdsButtonSize.small,
                        onPressed: _busy ? null : _pickReplacementPhoto,
                        child: const Text('Replace Photo'),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.componentSm),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: colors.labelAlternative,
                  ),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: WdsText(
                      "You can only have one photo per piece. Replacing will update this piece's photo.",
                      style: WdsTextStyle.caption1,
                      color: WdsTextColor.alternative,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.componentXl),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const WdsText('Caption', style: WdsTextStyle.heading1),
                  WdsText(
                    '$length/${Piece.commentMaxLength}',
                    style: WdsTextStyle.caption1,
                    color: WdsTextColor.alternative,
                  ),
                ],
              ),
              SizedBox(height: spacing.componentSm),
              WdsTextField(
                controller: _commentCtrl,
                placeholder:
                    'Write a short caption (max ${Piece.commentMaxLength} chars)...',
                maxLength: Piece.commentMaxLength,
                maxLines: 4,
                minLines: 4,
                disabled: _busy,
                errorText: _error,
                invalid: _error != null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
