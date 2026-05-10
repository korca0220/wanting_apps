import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/today_piece_provider.dart';
import '../widgets/compose_view.dart';
import '../widgets/error_view.dart';
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
          error: (e, _) => ErrorView(
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
