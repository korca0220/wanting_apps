import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Confirmation view shown after sign-up when email confirmation is enabled.
class ConfirmationSentView extends StatelessWidget {
  const ConfirmationSentView({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final spacing = context.wdsSpacing;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const WdsText('Check your email', style: WdsTextStyle.headline2),
        SizedBox(height: spacing.componentSm),
        WdsText(
          'Open the link we sent to $email to finish creating your account.',
          style: WdsTextStyle.body1,
          color: WdsTextColor.alternative,
        ),
        SizedBox(height: spacing.componentXl),
        WdsButton(
          onPressed: () => context.go('/sign-in'),
          child: const Text('Go to Sign In'),
        ),
      ],
    );
  }
}
