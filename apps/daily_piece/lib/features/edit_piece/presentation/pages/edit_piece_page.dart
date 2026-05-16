import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../piece_detail/presentation/providers/piece_by_id_provider.dart';
import '../../../piece_detail/presentation/widgets/error_view.dart';
import '../../../piece_detail/presentation/widgets/missing_view.dart';
import '../widgets/edit_piece_form.dart';

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
          : EditPieceForm(piece: p),
    );
  }
}
