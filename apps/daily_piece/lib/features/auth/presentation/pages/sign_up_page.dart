import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/repositories/auth_repository_impl.dart';
import '../../../../core/domain/exceptions/auth_exceptions.dart';
import '../widgets/confirmation_sent_view.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  bool _busy = false;
  String? _error;
  bool _confirmationSent = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    final confirm = _confirmPassword.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = '이메일과 비밀번호를 입력해주세요.');
      return;
    }
    if (password.length < 8) {
      setState(() => _error = '비밀번호는 8자 이상이어야 해요.');
      return;
    }
    if (password != confirm) {
      setState(() => _error = '비밀번호가 일치하지 않아요.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      final immediate = await ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password);
      if (!mounted) return;

      if (immediate) {
        // Confirm email = OFF: signedInStream → router redirect로 이어짐.
        return;
      }

      setState(() => _confirmationSent = true);
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = '가입에 실패했어요. 잠시 후 다시 시도해주세요.');
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(spacing.componentXl),
          child: _confirmationSent
              ? ConfirmationSentView(email: _email.text.trim())
              : _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final spacing = context.wdsSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const WdsText('Create Account', style: WdsTextStyle.title1),
        SizedBox(height: spacing.componentSm),
        const WdsText(
          'Start your daily photo journal',
          style: WdsTextStyle.body1,
          color: WdsTextColor.alternative,
        ),
        SizedBox(height: spacing.componentXl),
        WdsTextField(
          controller: _name,
          label: 'Name (Optional)',
          placeholder: 'Enter your name',
          textInputAction: TextInputAction.next,
          disabled: _busy,
        ),
        SizedBox(height: spacing.componentMd),
        WdsTextField(
          controller: _email,
          label: 'Email',
          placeholder: 'your@email.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          disabled: _busy,
        ),
        SizedBox(height: spacing.componentMd),
        WdsTextField(
          controller: _password,
          label: 'Password',
          placeholder: 'Minimum 8 characters',
          obscureText: true,
          textInputAction: TextInputAction.next,
          disabled: _busy,
        ),
        SizedBox(height: spacing.componentMd),
        WdsTextField(
          controller: _confirmPassword,
          label: 'Confirm Password',
          placeholder: 'Re-enter your password',
          obscureText: true,
          textInputAction: TextInputAction.done,
          disabled: _busy,
          onSubmitted: (_) => _submit(),
          errorText: _error,
          invalid: _error != null,
        ),
        SizedBox(height: spacing.componentXl),
        WdsButton(
          onPressed: _busy ? null : _submit,
          loading: _busy,
          child: const Text('Create Account'),
        ),
        SizedBox(height: spacing.componentLg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WdsText(
              'Already have an account?',
              style: WdsTextStyle.body2,
              color: WdsTextColor.alternative,
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _busy ? null : () => context.go('/sign-in'),
              child: const WdsText(
                'Sign In',
                style: WdsTextStyle.body2,
                color: WdsTextColor.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.componentXl),
        const Center(
          child: WdsText(
            'By creating an account, you agree to our Terms of Service and Privacy Policy',
            style: WdsTextStyle.caption1,
            color: WdsTextColor.alternative,
          ),
        ),
      ],
    );
  }
}
