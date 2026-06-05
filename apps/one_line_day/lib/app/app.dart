import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/theme_mode_controller.dart';
import 'router.dart';

class OneLineDayApp extends ConsumerWidget {
  const OneLineDayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'OneLine Day',
      theme: WdsTheme.light(),
      darkTheme: WdsTheme.dark(),
      themeMode: ref.watch(themeModeControllerProvider),
      routerConfig: ref.watch(appRouterProvider),
    );
  }
}
