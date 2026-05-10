import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data/repositories/auth_repository_impl.dart';

/// Sign out row. Confirmation dialog before sign out so a fat-finger doesn't
/// log the user out mid-flow. signedInStream → router redirect handles the
/// post-signout navigation back to /sign-in.
class SignOutTile extends ConsumerStatefulWidget {
  const SignOutTile({super.key});

  @override
  ConsumerState<SignOutTile> createState() => _SignOutTileState();
}

class _SignOutTileState extends ConsumerState<SignOutTile> {
  bool _busy = false;

  Future<void> _confirm() async {
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

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;

    return ListTile(
      leading: Icon(Icons.logout, color: colors.statusNegative),
      title: const WdsText(
        '로그아웃',
        style: WdsTextStyle.body1,
        color: WdsTextColor.alternative,
      ),
      enabled: !_busy,
      onTap: _busy ? null : _confirm,
    );
  }
}
