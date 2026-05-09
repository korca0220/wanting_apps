import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_state.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Center(
        child: WdsButton(
          onPressed: () => ref.read(authProvider.notifier).state =
              const AuthState(isSignedIn: true),
          child: const Text('Continue (stub)'),
        ),
      ),
    );
  }
}
