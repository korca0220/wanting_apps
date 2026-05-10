import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/repositories/auth_repository_impl.dart';
import 'setting_row.dart';

/// Account card — Sign Out + Delete Account rows.
///
/// Delete is wired to a confirm dialog and then signs out as a placeholder.
/// Server-side account deletion needs an admin endpoint; that's out of
/// scope for the renewal.
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
        title: const Text('로그아웃할까요?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('로그아웃'),
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

  Future<void> _deleteAccount() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('계정을 삭제할까요?'),
        content: const Text(
          '저장한 모든 piece와 사진이 영구적으로 삭제돼요. 되돌릴 수 없어요.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('계정 삭제'),
          ),
        ],
      ),
    );

    if (ok != true || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '계정 삭제는 곧 지원돼요. 지금은 로그아웃만 진행됩니다.',
        ),
      ),
    );

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
          Container(height: 1, color: colors.lineNormalNeutral),
          SettingRow(
            icon: Icons.delete_outline,
            title: 'Delete Account',
            caption: 'Permanently remove your data',
            tone: SettingRowTone.negative,
            onTap: _busy ? null : _deleteAccount,
          ),
        ],
      ),
    );
  }
}
