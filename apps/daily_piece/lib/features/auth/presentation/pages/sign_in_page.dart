import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/repositories/auth_repository_impl.dart';
import '../../../../core/domain/exceptions/auth_exceptions.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;

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

    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .signIn(email: email, password: password);
      // signedInStream → router redirect가 /today로 보냄.
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = '로그인에 실패했어요. 잠시 후 다시 시도해주세요.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;

    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentXl),
          child: Column(
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
                placeholder: '••••••••',
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
                child: const Text('로그인'),
              ),
              SizedBox(height: spacing.componentMd),
              WdsButton(
                onPressed: _busy ? null : () => context.go('/sign-up'),
                variant: WdsButtonVariant.outlined,
                child: const Text('계정이 없어요 — 가입하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
