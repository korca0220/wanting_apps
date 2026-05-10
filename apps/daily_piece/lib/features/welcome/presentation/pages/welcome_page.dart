import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pre-auth landing — hero (logo + brand + tagline) over a footer with
/// Create Account (solid) and Sign In (outlined) actions.
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: colors.primarySubtle,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.photo_camera_outlined,
                    size: 48,
                    color: colors.primaryNormal,
                  ),
                ),
              ),
              SizedBox(height: spacing.componentXl),
              const Center(
                child: WdsText('DailyPiece', style: WdsTextStyle.title1),
              ),
              SizedBox(height: spacing.componentSm),
              const Center(
                child: WdsText(
                  'One photo + one caption per day',
                  style: WdsTextStyle.body1,
                  color: WdsTextColor.alternative,
                ),
              ),
              const Spacer(),
              WdsButton(
                onPressed: () => context.push('/sign-up'),
                child: const Text('Create Account'),
              ),
              SizedBox(height: spacing.componentMd),
              WdsButton(
                onPressed: () => context.push('/sign-in'),
                variant: WdsButtonVariant.outlined,
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
