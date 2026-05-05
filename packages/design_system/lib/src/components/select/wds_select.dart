import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

/// Single-value select / dropdown. Visually aligned with `WdsTextField`
/// (Phase D — pending). Wraps Material's `DropdownButtonFormField`.
class WdsSelect<T> extends StatelessWidget {
  const WdsSelect({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.placeholder,
    this.invalid = false,
  });

  final T? value;
  final List<WdsSelectOption<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? label;
  final String? placeholder;
  final bool invalid;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;
    final radii = context.wdsRadius;

    OutlineInputBorder border(Color c, {double w = 1}) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(radii.input),
      borderSide: BorderSide(color: c, width: w),
    );

    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: onChanged,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down, color: colors.labelAlternative),
      style: type.body2.copyWith(color: colors.labelNormal),
      dropdownColor: colors.backgroundElevatedNormal,
      borderRadius: BorderRadius.circular(radii.card),
      items: [
        for (final opt in items)
          DropdownMenuItem<T>(value: opt.value, child: Text(opt.label)),
      ],
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        labelStyle: type.label1.copyWith(color: colors.labelNeutral),
        hintStyle: type.body2.copyWith(color: colors.labelAssistive),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        filled: true,
        fillColor: colors.backgroundElevatedNormal,
        enabledBorder: border(
          invalid
              ? colors.statusNegative.withValues(alpha: 0.28)
              : colors.lineNormalNeutral,
        ),
        focusedBorder: border(
          invalid ? colors.statusNegative : colors.primaryNormal,
          w: 2,
        ),
        disabledBorder: border(colors.lineNormalAlternative),
        errorBorder: border(colors.statusNegative, w: 2),
      ),
    );
  }
}

class WdsSelectOption<T> {
  const WdsSelectOption({required this.value, required this.label});

  final T value;
  final String label;
}
