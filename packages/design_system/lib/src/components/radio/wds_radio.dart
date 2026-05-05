import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

enum WdsRadioSize { small, medium }

class WdsRadio<T> extends StatelessWidget {
  const WdsRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.size = WdsRadioSize.medium,
    this.invalid = false,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final WdsRadioSize size;
  final bool invalid;

  bool get _enabled => onChanged != null;
  bool get _selected => value == groupValue;
  double get _box => size == WdsRadioSize.small ? 16 : 20;
  double get _gap => size == WdsRadioSize.small ? 6 : 8;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;

    Color borderColor() {
      if (!_enabled) return colors.interactionDisable;
      if (invalid) return colors.statusNegative.withValues(alpha: 0.28);
      if (_selected) return colors.primaryNormal;
      return colors.lineNormalNeutral;
    }

    final dotSize = size == WdsRadioSize.small ? 8.0 : 10.0;

    final indicator = Container(
      width: _box,
      height: _box,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor(), width: _selected ? 2 : 1),
        color: _selected && _enabled ? colors.staticWhite : Colors.transparent,
      ),
      child: _selected && _enabled
          ? Center(
              child: Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colors.primaryNormal,
                ),
              ),
            )
          : null,
    );

    final body = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        if (label != null) ...[
          SizedBox(width: _gap),
          Flexible(
            child: Text(
              label!,
              style: type.body2.copyWith(
                color: _enabled ? colors.labelNormal : colors.labelDisable,
              ),
            ),
          ),
        ],
      ],
    );

    return Semantics(
      inMutuallyExclusiveGroup: true,
      checked: _selected,
      enabled: _enabled,
      label: label,
      child: InkWell(
        onTap: _enabled ? () => onChanged!(value) : null,
        borderRadius: BorderRadius.circular(_box / 2),
        child: body,
      ),
    );
  }
}
