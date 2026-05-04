import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

/// Multi-step progress indicator with discrete circular markers.
///
/// `current` is the **0-based active step**. Steps with index `< current`
/// are rendered as complete. Connector lines between steps follow the
/// completion of the *preceding* step.
class WdsProgressTracker extends StatelessWidget {
  const WdsProgressTracker({
    super.key,
    required this.steps,
    required this.current,
    this.indicatorSize = 24,
  });

  final List<String> steps;
  final int current;
  final double indicatorSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          _StepCell(
            label: steps[i],
            state: _stateFor(i),
            indicatorSize: indicatorSize,
          ),
          if (i != steps.length - 1)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: indicatorSize / 2 - 1),
                child: _Track(complete: i < current),
              ),
            ),
        ],
      ],
    );
  }

  _StepState _stateFor(int i) {
    if (i < current) return _StepState.complete;
    if (i == current) return _StepState.active;
    return _StepState.incomplete;
  }
}

enum _StepState { incomplete, active, complete }

class _StepCell extends StatelessWidget {
  const _StepCell({
    required this.label,
    required this.state,
    required this.indicatorSize,
  });

  final String label;
  final _StepState state;
  final double indicatorSize;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;

    final indicator = switch (state) {
      _StepState.incomplete => Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.backgroundNormalNormal,
            border: Border.all(color: colors.lineNormalNeutral, width: 1),
          ),
        ),
      _StepState.active => Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.backgroundNormalNormal,
            border: Border.all(color: colors.primaryNormal, width: 2),
          ),
          child: Center(
            child: Container(
              width: indicatorSize * 0.33,
              height: indicatorSize * 0.33,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primaryNormal,
              ),
            ),
          ),
        ),
      _StepState.complete => Container(
          width: indicatorSize,
          height: indicatorSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colors.primaryNormal,
          ),
          child: Icon(
            Icons.check,
            size: indicatorSize * 0.7,
            color: colors.staticWhite,
          ),
        ),
    };

    final labelColor = state == _StepState.incomplete
        ? colors.labelAlternative
        : colors.labelNormal;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(height: 6),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 80),
          child: Text(
            label,
            style: type.label2.copyWith(color: labelColor),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _Track extends StatelessWidget {
  const _Track({required this.complete});

  final bool complete;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    return Container(
      height: 2,
      color: complete ? colors.primaryNormal : colors.lineNormalNeutral,
    );
  }
}
