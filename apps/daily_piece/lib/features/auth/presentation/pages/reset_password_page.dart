import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/repositories/auth_repository_impl.dart';
import '../../../../core/domain/exceptions/auth_exceptions.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _email = TextEditingController();
  bool _busy = false;
  String? _error;
  bool _sent = false;

  @override
  void dispose() {
    _email.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    if (email.isEmpty) {
      setState(() => _error = '이메일을 입력해주세요.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref.read(authRepositoryProvider).resetPassword(email: email);
      if (mounted) setState(() => _sent = true);
    } on AuthFailure {
      // Generalized message — never confirm or deny account existence.
      if (mounted) setState(() => _sent = true);
    } catch (_) {
      if (mounted) {
        setState(() => _error = '재설정 요청에 실패했어요. 잠시 후 다시 시도해주세요.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.chevron_left),
          tooltip: '뒤로',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(spacing.componentXl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const WdsText(
                      'Reset Password',
                      style: WdsTextStyle.title1,
                    ),
                    SizedBox(height: spacing.componentSm),
                    const WdsText(
                      'Enter your email to receive a reset link',
                      style: WdsTextStyle.body1,
                      color: WdsTextColor.alternative,
                    ),
                    SizedBox(height: spacing.componentXl),
                    if (_sent)
                      WdsText(
                        'If an account exists for ${_email.text.trim()}, a reset link has been sent.',
                        style: WdsTextStyle.body1,
                      )
                    else ...[
                      WdsTextField(
                        controller: _email,
                        label: 'Email',
                        placeholder: 'your@email.com',
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        disabled: _busy,
                        onSubmitted: (_) => _submit(),
                        errorText: _error,
                        invalid: _error != null,
                      ),
                      SizedBox(height: spacing.componentXs),
                      const WdsText(
                        "We'll send a password reset link to this email",
                        style: WdsTextStyle.caption1,
                        color: WdsTextColor.alternative,
                      ),
                      SizedBox(height: spacing.componentLg),
                      WdsButton(
                        onPressed: _busy ? null : _submit,
                        loading: _busy,
                        child: const Text('Send Reset Link'),
                      ),
                    ],
                    SizedBox(height: spacing.componentLg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const WdsText(
                          'Remember your password?',
                          style: WdsTextStyle.body2,
                          color: WdsTextColor.alternative,
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: _busy ? null : () => context.pop(),
                          child: const WdsText(
                            'Sign In',
                            style: WdsTextStyle.body2,
                            color: WdsTextColor.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing.componentXl),
              child: const WdsText(
                'Need help? Contact our support team',
                style: WdsTextStyle.caption1,
                color: WdsTextColor.alternative,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
