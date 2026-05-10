import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// "확인 메일을 보냈어요" 안내 뷰. Confirm email = ON 프로젝트에서 가입 직후 노출.
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
        const WdsText('확인 메일을 보냈어요.', style: WdsTextStyle.headline2),
        SizedBox(height: spacing.componentSm),
        WdsText(
          '$email 으로 보낸 링크를 누르면 가입이 완료돼요.',
          style: WdsTextStyle.body1,
          color: WdsTextColor.alternative,
        ),
        SizedBox(height: spacing.componentXl),
        WdsButton(
          onPressed: () => context.go('/sign-in'),
          child: const Text('로그인 화면으로'),
        ),
      ],
    );
  }
}
