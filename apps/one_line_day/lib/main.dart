import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const OneLineDayApp());
}

class OneLineDayApp extends StatelessWidget {
  const OneLineDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneLine Day',
      theme: WdsTheme.light(),
      darkTheme: WdsTheme.dark(),
      home: const OneLineDayHomePage(),
    );
  }
}

class OneLineDayHomePage extends StatelessWidget {
  const OneLineDayHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.wdsColors;
    final spacing = context.wdsSpacing;

    return Scaffold(
      backgroundColor: colors.backgroundNormalNormal,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.componentLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const WdsText('OneLine Day', style: WdsTextStyle.title2),
              SizedBox(height: spacing.componentSm),
              const WdsText(
                '오늘을 한 줄로 남기는 앱',
                style: WdsTextStyle.body2,
                color: WdsTextColor.alternative,
              ),
              SizedBox(height: spacing.componentLg),
              WdsCard(
                child: Padding(
                  padding: EdgeInsets.all(spacing.componentMd),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WdsText('Today', style: WdsTextStyle.heading1),
                      SizedBox(height: spacing.componentSm),
                      const WdsText(
                        '화면 명세를 기준으로 Today 작성 흐름부터 구현할 예정입니다.',
                        style: WdsTextStyle.body2,
                        color: WdsTextColor.neutral,
                      ),
                      SizedBox(height: spacing.componentMd),
                      WdsButton(
                        onPressed: () {},
                        child: const Text('Save today'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
