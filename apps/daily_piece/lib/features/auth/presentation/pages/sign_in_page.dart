import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/data/repositories/auth_repository_impl.dart';
import '../../../../core/domain/exceptions/auth_exceptions.dart';
import '../widgets/google_sign_in_button.dart';

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
      // signedInStream → router redirect가 /my-pieces로 보냄.
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = '로그인에 실패했어요. 잠시 후 다시 시도해주세요.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _busy = true;
      _error = null;
    });

    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      // OAuth callback completes session; router redirect handles navigation.
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Google 로그인에 실패했어요. 잠시 후 다시 시도해주세요.');
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const WdsText('Welcome Back', style: WdsTextStyle.title1),
              SizedBox(height: spacing.componentSm),
              const WdsText(
                'Sign in to continue your journey',
                style: WdsTextStyle.body1,
                color: WdsTextColor.alternative,
              ),
              SizedBox(height: spacing.componentXl),
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
                placeholder: '••••••••',
                obscureText: true,
                textInputAction: TextInputAction.done,
                disabled: _busy,
                onSubmitted: (_) => _submit(),
                errorText: _error,
                invalid: _error != null,
              ),
              SizedBox(height: spacing.componentSm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _busy
                      ? null
                      : () => context.push('/reset-password'),
                  child: const Text('Forgot password?'),
                ),
              ),
              SizedBox(height: spacing.componentMd),
              WdsButton(
                onPressed: _busy ? null : _submit,
                loading: _busy,
                child: const Text('Sign In'),
              ),
              SizedBox(height: spacing.componentMd),
              GoogleSignInButton(
                onPressed: _busy ? null : _signInWithGoogle,
              ),
              SizedBox(height: spacing.componentLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const WdsText(
                    "Don't have an account?",
                    style: WdsTextStyle.body2,
                    color: WdsTextColor.alternative,
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _busy ? null : () => context.push('/sign-up'),
                    child: const WdsText(
                      'Create Account',
                      style: WdsTextStyle.body2,
                      color: WdsTextColor.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.componentXl),
              const Center(
                child: WdsText(
                  'By signing in, you agree to our Terms of Service and Privacy Policy',
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
