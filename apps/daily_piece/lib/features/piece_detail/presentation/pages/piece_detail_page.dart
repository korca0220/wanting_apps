import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/piece_by_id_provider.dart';
import '../widgets/detail_scaffold.dart';
import '../widgets/error_view.dart';
import '../widgets/missing_view.dart';

class PieceDetailPage extends ConsumerWidget {
  const PieceDetailPage({super.key, required this.pieceId});

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
          : DetailScaffold(piece: p),
    );
  }
}
