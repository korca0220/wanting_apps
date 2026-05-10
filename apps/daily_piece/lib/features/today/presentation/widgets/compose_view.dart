import 'dart:typed_data';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/media/photo_picker.dart';
import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';
import '../../../../core/domain/exceptions/piece_exceptions.dart';
import '../providers/today_piece_provider.dart';
import 'photo_placeholder.dart';

/// Compose mode — no Piece for today yet. Pick → preview → comment → save.
class ComposeView extends ConsumerStatefulWidget {
  const ComposeView({super.key});

  @override
  ConsumerState<ComposeView> createState() => _ComposeViewState();
}

class _ComposeViewState extends ConsumerState<ComposeView> {
  final _comment = TextEditingController();
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
      final bytes = await pickAndProcessPhoto(context);
      if (!mounted) return;

      setState(() {
        if (bytes != null) _photoBytes = bytes;
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
                    : PhotoPlaceholder(busy: _busy),
              ),
            ),
          ),
          SizedBox(height: spacing.componentLg),
          WdsTextField(
            controller: _comment,
            label: '코멘트',
            placeholder: '오늘을 한 줄로 (최대 ${Piece.commentMaxLength}자)',
            maxLength: Piece.commentMaxLength,
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
