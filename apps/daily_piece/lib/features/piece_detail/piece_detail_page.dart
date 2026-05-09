import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PieceDetailPage extends ConsumerWidget {
  const PieceDetailPage({required this.pieceId, super.key});

  final String pieceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Piece $pieceId')),
      body: const Center(child: Text('Piece detail — TODO')),
    );
  }
}
