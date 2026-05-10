import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/current_user_provider.dart';
import '../widgets/account_card.dart';
import '../widgets/profile_card.dart';
import '../widgets/settings_card.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.componentXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (user != null) ProfileCard(user: user),
              SizedBox(height: spacing.componentXl),
              const SettingsCard(),
              SizedBox(height: spacing.componentXl),
              const AccountCard(),
              SizedBox(height: spacing.componentXl),
              const Center(
                child: WdsText(
                  'DailyPiece v1.0.0',
                  style: WdsTextStyle.caption1,
                  color: WdsTextColor.alternative,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
