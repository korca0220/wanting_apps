import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

/// Single-line text input.
///
/// Per `docs/components/02-text-field.md`. Slot variants for leading /
/// trailing are kept lightweight: any [Widget] is accepted. The web
/// signature `backdrop-filter: blur(32px)` is **not** ported (Flutter's
/// `BackdropFilter` requires a translucent ancestor; we render with
/// `backgroundElevatedNormal` instead). Tracked in 02-text-field.md.
class WdsTextField extends StatefulWidget {
  const WdsTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.label,
    this.placeholder,
    this.helperText,
    this.errorText,
    this.invalid = false,
    this.positive = false,
    this.disabled = false,
    this.readOnly = false,
    this.obscureText = false,
    this.leading,
    this.trailing,
    this.clearable = false,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.minLines,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final String? label;
  final String? placeholder;
  final String? helperText;
  final String? errorText;
  final bool invalid;
  final bool positive;
  final bool disabled;
  final bool readOnly;
  final bool obscureText;
  final Widget? leading;
  final Widget? trailing;
  final bool clearable;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;

  @override
  State<WdsTextField> createState() => _WdsTextFieldState();
}

class _WdsTextFieldState extends State<WdsTextField> {
  late TextEditingController _controller;
  late bool _ownsController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
      _ownsController = false;
    } else {
      _controller = TextEditingController(text: widget.initialValue);
      _ownsController = true;
    }
    _controller.addListener(_onChanged);
  }

  @override
  void didUpdateWidget(WdsTextField old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      _controller.removeListener(_onChanged);
      if (_ownsController) _controller.dispose();
      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownsController = false;
      } else {
        _controller = TextEditingController(text: widget.initialValue);
        _ownsController = true;
      }
      _controller.addListener(_onChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final type = context.wdsType;
    final radii = context.wdsRadius;

    Color borderColor() {
      if (widget.disabled) return colors.lineNormalAlternative;
      if (widget.invalid) return colors.statusNegative.withValues(alpha: 0.28);
      if (widget.positive) {
        return colors.statusPositive.withValues(alpha: 0.28);
      }
      return colors.lineNormalNeutral;
    }

    OutlineInputBorder border(Color c, {double w = 1}) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(radii.input),
          borderSide: BorderSide(color: c, width: w),
        );

    Widget? trailing = widget.trailing;
    if (widget.clearable && _controller.text.isNotEmpty && !widget.readOnly) {
      final clear = IconButton(
        tooltip: '입력 지우기',
        onPressed: widget.disabled
            ? null
            : () {
                _controller.clear();
                widget.onChanged?.call('');
              },
        iconSize: 18,
        icon: Icon(Icons.cancel, color: colors.labelAssistive),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
      );
      trailing = trailing == null
          ? clear
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [clear, const SizedBox(width: 4), trailing],
            );
    }
    if (widget.invalid) {
      final icon = Icon(Icons.error, color: colors.statusNegative, size: 18);
      trailing = trailing == null
          ? icon
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [icon, const SizedBox(width: 4), trailing],
            );
    } else if (widget.positive) {
      final icon = Icon(Icons.check_circle,
          color: colors.statusPositive, size: 18);
      trailing = trailing == null
          ? icon
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [icon, const SizedBox(width: 4), trailing],
            );
    }

    return TextField(
      controller: _controller,
      focusNode: widget.focusNode,
      enabled: !widget.disabled,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      style: type.body1.copyWith(
        color: widget.disabled ? colors.labelDisable : colors.labelNormal,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.placeholder,
        helperText: widget.errorText ?? widget.helperText,
        helperStyle: type.caption1.copyWith(
          color:
              widget.errorText != null || widget.invalid
                  ? colors.statusNegative
                  : colors.labelAlternative,
        ),
        labelStyle: type.label1.copyWith(color: colors.labelNeutral),
        hintStyle: type.body1.copyWith(color: colors.labelAssistive),
        prefixIcon: widget.leading,
        suffixIcon: trailing,
        filled: true,
        fillColor: widget.disabled
            ? colors.fillAlternative
            : colors.backgroundElevatedNormal,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        enabledBorder: border(borderColor()),
        focusedBorder: border(
          widget.invalid ? colors.statusNegative : colors.primaryNormal,
          w: 2,
        ),
        disabledBorder: border(colors.lineNormalAlternative),
        errorBorder: border(colors.statusNegative, w: 2),
      ),
    );
  }
}
