import 'package:design_system/design_system.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const _kTermsUrl =
    'https://junewoo.notion.site/dailypiece-36b02a624614811aa6cccab3e56c9d88';
const _kPrivacyUrl =
    'https://junewoo.notion.site/dailypiece-36b02a624614806eb21ef631ef6e3889';

class LegalText extends StatelessWidget {
  const LegalText({super.key, required this.prefix});

  final String prefix;

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final captionStyle = context.wdsType.caption1.copyWith(
      color: colors.labelAlternative,
    );
    final linkStyle = captionStyle.copyWith(
      decoration: TextDecoration.underline,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: captionStyle,
        children: [
          TextSpan(text: '$prefix '),
          TextSpan(
            text: 'Terms of Service',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => launchUrl(
                    Uri.parse(_kTermsUrl),
                    mode: LaunchMode.externalApplication,
                  ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () => launchUrl(
                    Uri.parse(_kPrivacyUrl),
                    mode: LaunchMode.externalApplication,
                  ),
          ),
        ],
      ),
    );
  }
}
