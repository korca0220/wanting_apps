import 'dart:typed_data';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/domain/piece.dart';
import 'media_pipeline.dart';
import 'piece_repository.dart';
import 'today_piece_provider.dart';

class TodayPage extends ConsumerWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final today = ref.watch(todayPieceProvider);
    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('Today')),
      body: SafeArea(
        child: today.when(
          loading: () => const Center(child: WdsSpinner()),
          error: (e, _) => _ErrorView(error: e, onRetry: () {
            // ignore: unused_result
            ref.refresh(todayPieceProvider);
          }),
          data: (piece) => piece == null
              ? const _ComposeView()
              : _PieceView(piece: piece),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.error, required this.onRetry});
  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.componentXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WdsText('오늘의 Piece를 불러오지 못했어요.',
                style: WdsTextStyle.headline2),
            SizedBox(height: spacing.componentSm),
            WdsText('$error',
                style: WdsTextStyle.body2,
                color: WdsTextColor.alternative),
            SizedBox(height: spacing.componentXl),
            WdsButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}

/// View mode — today's Piece already saved. Read-only for now (edit/delete is
/// a follow-up flow).
class _PieceView extends ConsumerStatefulWidget {
  const _PieceView({required this.piece});
  final Piece piece;

  @override
  ConsumerState<_PieceView> createState() => _PieceViewState();
}

class _PieceViewState extends ConsumerState<_PieceView> {
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

/// Compose mode — no Piece for today yet. Pick → preview → comment → save.
class _ComposeView extends ConsumerStatefulWidget {
  const _ComposeView();

  @override
  ConsumerState<_ComposeView> createState() => _ComposeViewState();
}

class _ComposeViewState extends ConsumerState<_ComposeView> {
  final _comment = TextEditingController();
  final _picker = ImagePicker();
  Uint8List? _photoBytes;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
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
        _photoBytes = bytes;
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
    final bytes = _photoBytes;
    if (bytes == null) return;
    final comment = _comment.text.trim();
    if (comment.isEmpty) {
      setState(() => _error = '코멘트를 입력해주세요.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(pieceRepositoryProvider)
          .create(photoBytes: bytes, comment: comment);
      // ignore: unused_result
      ref.refresh(todayPieceProvider);
    } on PieceAlreadyExistsToday {
      if (mounted) {
        setState(() => _error = '오늘의 Piece가 이미 저장돼있어요.');
        // ignore: unused_result
        ref.refresh(todayPieceProvider);
      }
    } catch (e) {
      if (mounted) setState(() => _error = '저장에 실패했어요: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final hasPhoto = _photoBytes != null;
    return Padding(
      padding: EdgeInsets.all(spacing.componentXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: _busy ? null : _pickPhoto,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: hasPhoto
                    ? Image.memory(_photoBytes!, fit: BoxFit.cover)
                    : _PhotoPlaceholder(busy: _busy),
              ),
            ),
          ),
          SizedBox(height: spacing.componentLg),
          WdsTextField(
            controller: _comment,
            label: '코멘트',
            placeholder: '오늘을 한 줄로 (최대 ${Piece.commentMaxLength}자)',
            disabled: _busy || !hasPhoto,
            errorText: _error,
            invalid: _error != null,
          ),
          SizedBox(height: spacing.componentXl),
          WdsButton(
            onPressed: (_busy || !hasPhoto) ? null : _save,
            loading: _busy && hasPhoto,
            child: const Text('오늘의 Piece 저장'),
          ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder({required this.busy});
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    return Container(
      color: colors.backgroundNormalAlternative,
      child: Center(
        child: busy
            ? const WdsSpinner()
            : const WdsText(
                '탭해서 사진 고르기',
                style: WdsTextStyle.body1,
                color: WdsTextColor.alternative,
              ),
      ),
    );
  }
}
