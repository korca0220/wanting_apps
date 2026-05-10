import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/repositories/piece_repository_impl.dart';
import '../../../../core/domain/entities/piece.dart';
import '../providers/piece_by_id_provider.dart';

class PieceDetailPage extends ConsumerWidget {
  const PieceDetailPage({super.key, required this.pieceId});

  final String pieceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final piece = ref.watch(pieceByIdProvider(pieceId));

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(),
      body: SafeArea(
        child: piece.when(
          loading: () => const Center(child: WdsSpinner()),
          error: (e, _) => _ErrorView(
            error: e,
            onRetry: () => ref.invalidate(pieceByIdProvider(pieceId)),
          ),
          data: (p) => p == null ? const _MissingView() : _DetailBody(piece: p),
        ),
      ),
    );
  }
}

class _DetailBody extends ConsumerStatefulWidget {
  const _DetailBody({required this.piece});

  final Piece piece;

  @override
  ConsumerState<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends ConsumerState<_DetailBody> {
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

    return SingleChildScrollView(
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
          WdsText(widget.piece.comment, style: WdsTextStyle.headline2),
          SizedBox(height: spacing.componentSm),
          WdsText(
            _formatDate(widget.piece.date),
            style: WdsTextStyle.body2,
            color: WdsTextColor.alternative,
          ),
          SizedBox(height: spacing.componentXl),
        ],
      ),
    );
  }
}

String _formatDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');

  return '$y. $m. $day';
}

class _MissingView extends StatelessWidget {
  const _MissingView();

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.componentXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const WdsText('Piece를 찾을 수 없어요.', style: WdsTextStyle.headline2),
            SizedBox(height: spacing.componentSm),
            const WdsText(
              '이미 삭제됐거나 접근 권한이 없어요.',
              style: WdsTextStyle.body2,
              color: WdsTextColor.alternative,
            ),
            SizedBox(height: spacing.componentXl),
            WdsButton(
              onPressed: () => context.go('/collection'),
              child: const Text('컬렉션으로'),
            ),
          ],
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
            const WdsText('Piece를 불러오지 못했어요.', style: WdsTextStyle.headline2),
            SizedBox(height: spacing.componentSm),
            WdsText(
              '$error',
              style: WdsTextStyle.body2,
              color: WdsTextColor.alternative,
            ),
            SizedBox(height: spacing.componentXl),
            WdsButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      ),
    );
  }
}
