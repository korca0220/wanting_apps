import 'package:flutter/material.dart';

import '../text_field/wds_text_field.dart';

/// Multi-line auto-growing input. Reuses [WdsTextField] shell.
class WdsTextarea extends StatelessWidget {
  const WdsTextarea({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.invalid = false,
    this.disabled = false,
    this.readOnly = false,
    this.minLines = 3,
    this.maxLines,
    this.onChanged,
    this.focusNode,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final bool invalid;
  final bool disabled;
  final bool readOnly;
  final int minLines;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return WdsTextField(
      controller: controller,
      initialValue: initialValue,
      label: label,
      placeholder: placeholder,
      helperText: helperText,
      errorText: errorText,
      invalid: invalid,
      disabled: disabled,
      readOnly: readOnly,
      onChanged: onChanged,
      focusNode: focusNode,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: minLines,
      maxLines: maxLines,
    );
  }
}
