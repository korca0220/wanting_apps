import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class EmptyResults extends StatelessWidget {
  const EmptyResults({super.key, required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;
    final msg = query.isEmpty
        ? '아직 저장된 piece가 없어요.'
        : "'$query'에 대한 결과가 없어요.";

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
