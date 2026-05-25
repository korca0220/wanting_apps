import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/repositories/auth_repository_impl.dart';
import 'setting_row.dart';

class AccountCard extends ConsumerStatefulWidget {
  const AccountCard({super.key});

  @override
  ConsumerState<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends ConsumerState<AccountCard> {
  bool _busy = false;

  Future<void> _signOut() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    setState(() => _busy = true);

    try {
      await ref.read(authRepositoryProvider).signOut();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundElevatedNormal,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.lineNormalNeutral),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
            child: WdsText('Account', style: WdsTextStyle.heading1),
          ),
          Container(height: 1, color: colors.lineNormalNeutral),
          SettingRow(
            icon: Icons.logout,
            title: 'Sign Out',
            titleCentered: true,
            onTap: _busy ? null : _signOut,
          ),
        ],
      ),
    );
  }
}
