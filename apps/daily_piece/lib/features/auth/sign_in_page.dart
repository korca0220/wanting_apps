import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: const Center(
        child: WdsText(
          'Sign in form — TODO',
          style: WdsTextStyle.headline2,
          color: WdsTextColor.alternative,
        ),
      ),
    );
  }
}
