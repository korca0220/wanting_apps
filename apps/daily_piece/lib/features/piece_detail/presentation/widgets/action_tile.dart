import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum ActionTone { primary, negative }

class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.tone,
    required this.disabled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final ActionTone tone;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final color = tone == ActionTone.primary
        ? colors.primaryNormal
        : colors.statusNegative;

    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: colors.backgroundElevatedNormal,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.lineNormalNeutral),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: spacing.componentLg,
          vertical: spacing.componentMd,
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            SizedBox(width: spacing.componentMd),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: colors.labelAlternative),
          ],
        ),
      ),
    );
  }
}
