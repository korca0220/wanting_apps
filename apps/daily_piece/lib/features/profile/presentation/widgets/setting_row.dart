import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

enum SettingRowTone { primary, neutral, negative }

/// Card row used by Settings/Account cards. Leading icon tile + title +
/// optional caption + optional trailing slot. Tone tints the leading tile
/// and (for negative) the title.
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.icon,
    required this.title,
    this.caption,
    this.trailing,
    this.onTap,
    this.tone = SettingRowTone.primary,
    this.titleCentered = false,
  });

  final IconData icon;
  final String title;
  final String? caption;
  final Widget? trailing;
  final VoidCallback? onTap;
  final SettingRowTone tone;
  final bool titleCentered;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final (tileBg, iconColor, titleColor) = switch (tone) {
      SettingRowTone.primary => (
        colors.primarySubtle,
        colors.primaryNormal,
        colors.labelStrong,
      ),
      SettingRowTone.neutral => (
        colors.fillAlternative,
        colors.labelAlternative,
        colors.labelStrong,
      ),
      SettingRowTone.negative => (
        colors.statusNegative.withValues(alpha: 0.1),
        colors.statusNegative,
        colors.statusNegative,
      ),
    };

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.componentXl,
          vertical: spacing.componentLg,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: tileBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            SizedBox(width: spacing.componentMd),
            Expanded(
              child: Column(
                crossAxisAlignment: titleCentered
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (caption != null) ...[
                    const SizedBox(height: 2),
                    WdsText(
                      caption!,
                      style: WdsTextStyle.caption1,
                      color: WdsTextColor.alternative,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing!,
            if (onTap != null)
              Icon(Icons.chevron_right, color: colors.labelAlternative),
          ],
        ),
      ),
    );
  }
}
