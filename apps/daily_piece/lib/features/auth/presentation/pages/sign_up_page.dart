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
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;
  bool _confirmationSent = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = '이메일과 비밀번호를 입력해주세요.');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = '비밀번호는 6자 이상이어야 해요.');
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

      // Confirm email = ON: 메일 확인 안내로 전환.
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
    final spacing = context.wdsSpacing;

    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: SafeArea(
        child: Padding(
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
        WdsTextField(
          controller: _email,
          label: '이메일',
          placeholder: 'you@example.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          disabled: _busy,
        ),
        SizedBox(height: spacing.componentMd),
        WdsTextField(
          controller: _password,
          label: '비밀번호',
          placeholder: '6자 이상',
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
          child: const Text('가입하기'),
        ),
        SizedBox(height: spacing.componentMd),
        WdsButton(
          onPressed: _busy ? null : () => context.go('/sign-in'),
          variant: WdsButtonVariant.outlined,
          child: const Text('이미 계정이 있어요 — 로그인'),
        ),
      ],
    );
  }
}
