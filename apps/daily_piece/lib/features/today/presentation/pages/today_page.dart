import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/today_piece_provider.dart';
import '../widgets/compose_view.dart';
import '../widgets/piece_view.dart';

/// Routes the AsyncValue for today's Piece into one of three states:
/// loading, error, compose (null), view (Piece).
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
          error: (e, _) => _ErrorView(
            error: e,
            onRetry: () {
              // ignore: unused_result
              ref.refresh(todayPieceProvider);
            },
          ),
          data: (piece) =>
              piece == null ? const ComposeView() : PieceView(piece: piece),
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
            const WdsText(
              '오늘의 Piece를 불러오지 못했어요.',
              style: WdsTextStyle.headline2,
            ),
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
