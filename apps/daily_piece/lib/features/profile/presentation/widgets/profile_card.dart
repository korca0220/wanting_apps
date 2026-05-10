import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

import '../providers/current_user_provider.dart';

const _monthsLong = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user});

  final CurrentUser user;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final joined = user.joinedAt;
    final memberSince = '${_monthsLong[joined.month - 1]} ${joined.year}';

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.lineNormalNeutral),
      ),
      padding: EdgeInsets.all(spacing.componentXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: colors.primarySubtle,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.primaryNormal, width: 2),
                ),
                child: Icon(
                  Icons.person,
                  size: 40,
                  color: colors.primaryNormal,
                ),
              ),
              SizedBox(width: spacing.componentLg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WdsText(
                      user.name ?? user.email.split('@').first,
                      style: WdsTextStyle.heading1,
                    ),
                    SizedBox(height: spacing.componentXs),
                    WdsText(
                      user.email,
                      style: WdsTextStyle.body2,
                      color: WdsTextColor.alternative,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.componentLg),
          Container(height: 1, color: colors.lineNormalNeutral),
          SizedBox(height: spacing.componentLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const WdsText(
                'Member since',
                style: WdsTextStyle.body2,
                color: WdsTextColor.alternative,
              ),
              WdsText(memberSince, style: WdsTextStyle.label1),
            ],
          ),
        ],
      ),
    );
  }
}
