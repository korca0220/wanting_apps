import 'dart:typed_data';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/media/photo_picker.dart';
import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';
import '../../../../core/domain/exceptions/piece_exceptions.dart';
import '../../../my_pieces/presentation/providers/my_pieces_feed_provider.dart';
import '../../../search/presentation/providers/search_providers.dart';
import 'photo_picker_tile.dart';

/// Modal bottom sheet for creating a new Piece. Pick photo → caption → save.
/// On success, pops the sheet and invalidates the My Pieces feed.
///
/// [forDate] defaults to today; the calendar passes a specific day when the
/// user taps an empty past cell.
///
/// Use [showNewPieceSheet] from a widget to invoke; this isn't a routed page.
class NewPieceSheet extends ConsumerStatefulWidget {
  const NewPieceSheet({super.key, this.forDate});

  final DateTime? forDate;

  @override
  ConsumerState<NewPieceSheet> createState() => _NewPieceSheetState();
}

class _NewPieceSheetState extends ConsumerState<NewPieceSheet> {
  final _comment = TextEditingController();
  Uint8List? _photoBytes;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    // Live counter — each keystroke triggers a rebuild for the n/50 label.
    _comment.addListener(_onCommentChanged);
  }

  @override
  void dispose() {
    _comment
      ..removeListener(_onCommentChanged)
      ..dispose();

    super.dispose();
  }

  void _onCommentChanged() => setState(() {});

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
          .create(
            photoBytes: bytes,
            comment: comment,
            date: widget.forDate,
          );

      ref.invalidate(myPiecesFeedProvider);
      ref.invalidate(pieceMonthsProvider);
      ref.invalidate(searchResultsProvider);

      if (mounted) Navigator.of(context).pop();
    } on PieceAlreadyExistsToday {
      if (mounted) {
        setState(() {
          _error = '해당 날짜의 Piece가 이미 저장돼있어요.';
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

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final hasPhoto = _photoBytes != null;
    final commentLength = _comment.text.length;
    final canSubmit = hasPhoto && _comment.text.trim().isNotEmpty && !_busy;
    // Sheet height grows with the keyboard so the textarea stays in view.
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.backgroundNormalNormal,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(spacing.componentXl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const WdsText('New Piece', style: WdsTextStyle.headline2),
                    IconButton(
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      tooltip: '닫기',
                    ),
                  ],
                ),
                SizedBox(height: spacing.componentLg),
                PhotoPickerTile(
                  bytes: _photoBytes,
                  busy: _busy && !hasPhoto,
                  onTap: _pickPhoto,
                ),
                SizedBox(height: spacing.componentLg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const WdsText('Caption', style: WdsTextStyle.heading1),
                    WdsText(
                      '$commentLength/${Piece.commentMaxLength}',
                      style: WdsTextStyle.caption1,
                      color: WdsTextColor.alternative,
                    ),
                  ],
                ),
                SizedBox(height: spacing.componentSm),
                WdsTextField(
                  controller: _comment,
                  placeholder:
                      'Write a short caption (max ${Piece.commentMaxLength} chars)...',
                  maxLength: Piece.commentMaxLength,
                  maxLines: 4,
                  minLines: 4,
                  disabled: _busy,
                  errorText: _error,
                  invalid: _error != null,
                ),
                SizedBox(height: spacing.componentXl),
                WdsButton(
                  onPressed: canSubmit ? _save : null,
                  loading: _busy && hasPhoto,
                  child: const Text('Save Piece'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the New Piece bottom sheet. Returns once the sheet is dismissed
/// (saved or cancelled). Pass [forDate] to fill in a non-today day.
Future<void> showNewPieceSheet(BuildContext context, {DateTime? forDate}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => NewPieceSheet(forDate: forDate),
  );
}
