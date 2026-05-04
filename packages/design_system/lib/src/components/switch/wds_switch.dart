import 'package:flutter/material.dart';

import '../../theme/wds_theme_ext.dart';

enum WdsSwitchSize { small, medium }

/// Boolean toggle. Use for *system state* changes that apply immediately
/// (Checkbox is for *form value*).
class WdsSwitch extends StatelessWidget {
  const WdsSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.size = WdsSwitchSize.medium,
    this.semanticLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final WdsSwitchSize size;
  final String? semanticLabel;

  bool get _enabled => onChanged != null;

  double get _trackWidth => size == WdsSwitchSize.medium ? 44 : 32;
  double get _trackHeight => size == WdsSwitchSize.medium ? 24 : 18;
  double get _thumb => size == WdsSwitchSize.medium ? 20 : 14;
  double get _padding => 2;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final shadows = context.wdsShadows;
    final motion = context.wdsMotion;

    Color trackColor() {
      if (!_enabled) return colors.interactionDisable;
      return value ? colors.primaryNormal : colors.interactionInactive;
    }

    final thumbOffset = value ? _trackWidth - _thumb - _padding : _padding;

    final track = AnimatedContainer(
      duration: motion.durationFast,
      curve: motion.easingDecelerate,
      width: _trackWidth,
      height: _trackHeight,
      decoration: BoxDecoration(
        color: trackColor(),
        borderRadius: BorderRadius.circular(_trackHeight / 2),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: motion.durationFast,
            curve: motion.easingDecelerate,
            left: thumbOffset,
            top: _padding,
            child: Container(
              width: _thumb,
              height: _thumb,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.staticWhite,
                boxShadow: shadows.normalXSmall,
              ),
            ),
          ),
        ],
      ),
    );

    return Semantics(
      toggled: value,
      enabled: _enabled,
      label: semanticLabel,
      child: GestureDetector(
        onTap: _enabled ? () => onChanged!(!value) : null,
        behavior: HitTestBehavior.opaque,
        child: track,
      ),
    );
  }
}
