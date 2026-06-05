import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/presentation/pages/calendar_page.dart';
import '../features/entries/presentation/pages/entries_page.dart';
import '../features/search/presentation/pages/search_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/today/presentation/pages/today_page.dart';
import 'shell/main_shell_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/today',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShellPage(navigationShell: shell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: '/today', builder: (_, _) => const TodayPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/calendar', builder: (_, _) => const CalendarPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/entries', builder: (_, _) => const EntriesPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/search', builder: (_, _) => const SearchPage()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: '/settings', builder: (_, _) => const SettingsPage()),
          ]),
        ],
      ),
    ],
  );
});
