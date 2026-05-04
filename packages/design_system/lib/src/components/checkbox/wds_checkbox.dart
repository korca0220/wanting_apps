import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

enum WdsCheckboxSize { small, medium }

/// Checkbox with optional label. Supports indeterminate (`value == null`),
/// invalid border, required adornment.
class WdsCheckbox extends StatelessWidget {
  const WdsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.size = WdsCheckboxSize.medium,
    this.invalid = false,
    this.required = false,
    this.bold = false,
  });

  /// `true` checked, `false` unchecked, `null` indeterminate.
  final bool? value;

  final ValueChanged<bool?>? onChanged;
  final String? label;
  final WdsCheckboxSize size;
  final bool invalid;
  final bool required;
  final bool bold;

  bool get _enabled => onChanged != null;

  double get _box => size == WdsCheckboxSize.small ? 16 : 20;
  double get _gap => size == WdsCheckboxSize.small ? 6 : 8;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;

    Color resolveFill(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return colors.interactionDisable;
      }
      if (states.contains(WidgetState.selected)) return colors.primaryNormal;
      if (states.contains(WidgetState.hovered)) return colors.fillAlternative;
      return Colors.transparent;
    }

    BorderSide resolveSide(Set<WidgetState> states) {
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(color: colors.interactionDisable, width: 1);
      }
      if (invalid) {
        return BorderSide(
          color: colors.statusNegative.withValues(alpha: 0.28),
          width: 1.5,
        );
      }
      if (states.contains(WidgetState.selected)) {
        return BorderSide(color: colors.primaryNormal, width: 1);
      }
      if (states.contains(WidgetState.hovered)) {
        return BorderSide(color: colors.lineNormalNormal, width: 1);
      }
      return BorderSide(color: colors.lineNormalNeutral, width: 1);
    }

    final box = Transform.scale(
      scale: _box / 18, // Material Checkbox renders ~18px; scale to spec.
      child: Checkbox(
        value: value,
        tristate: true,
        onChanged: onChanged,
        activeColor: colors.primaryNormal,
        checkColor: colors.staticWhite,
        fillColor: WidgetStateProperty.resolveWith(resolveFill),
        side: const BorderSide(width: 1), // overridden via mat. resolution
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );

    // Material's `side` prop only accepts a single BorderSide; for dynamic
    // resolution we wrap manually via Container if invalid OR draw via
    // `side: WidgetStateBorderSide.resolveWith(...)`.
    final boxWithDynamicSide = Theme(
      data: Theme.of(context).copyWith(
        checkboxTheme: CheckboxThemeData(
          side: WidgetStateBorderSide.resolveWith(resolveSide),
        ),
      ),
      child: box,
    );

    final body = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: _box, height: _box, child: boxWithDynamicSide),
        if (label != null) ...[
          SizedBox(width: _gap),
          Flexible(
            child: Text.rich(
              TextSpan(
                text: label!,
                style: type.body2.copyWith(
                  fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                  color: _enabled ? colors.labelNormal : colors.labelDisable,
                ),
                children: [
                  if (required)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: colors.statusNegative),
                    ),
                ],
              ),
            ),
          ),
        ],
      ],
    );

    return Semantics(
      checked: value == true,
      mixed: value == null,
      enabled: _enabled,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _enabled
            ? () {
                // From any state, a user tap moves to checked (`true`) if
                // currently unchecked or indeterminate; otherwise unchecks.
                onChanged!(value == true ? false : true);
              }
            : null,
        child: body,
      ),
    );
  }
}
