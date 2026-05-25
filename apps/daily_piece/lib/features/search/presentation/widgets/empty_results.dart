import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class EmptyResults extends StatelessWidget {
  const EmptyResults({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final msg = query.isEmpty
        ? 'No pieces saved yet.'
        : "No results for '$query'.";

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.componentXl),
        child: WdsText(
          msg,
          style: WdsTextStyle.body1,
          color: WdsTextColor.alternative,
        ),
      ),
    );
  }
}
