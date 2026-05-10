import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

/// Stub. Implementation lands in the Search step of the renewal —
/// see docs/screens/02-search.md.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('Search')),
      body: const Center(
        child: WdsText('Coming soon', style: WdsTextStyle.body1),
      ),
    );
  }
}
