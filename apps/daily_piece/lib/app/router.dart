import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/session_provider.dart';
import '../features/auth/sign_in_page.dart';
import '../features/auth/sign_up_page.dart';
import '../features/collection/presentation/pages/collection_page.dart';
import '../features/piece_detail/presentation/pages/piece_detail_page.dart';
import '../features/settings/settings_page.dart';
import '../features/today/presentation/pages/today_page.dart';
import 'shell/main_shell_page.dart';

const _authPaths = {'/sign-in', '/sign-up'};

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/today',
    redirect: (context, state) {
      final signedIn = ref.read(isSignedInProvider);
      final atAuth = _authPaths.contains(state.matchedLocation);
      if (!signedIn && !atAuth) return '/sign-in';
      if (signedIn && atAuth) return '/today';
      return null;
    },
    refreshListenable: _RouterRefresh(ref),
    routes: [
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (_, _) => const SignUpPage()),
      // Bottom-nav shell. Each branch keeps its own navigator so deep links
      // into a tab (e.g. /collection/:pieceId) keep their back stack when the
      // user switches tabs and comes back.
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShellPage(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/today', builder: (_, _) => const TodayPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/collection',
                builder: (_, _) => const CollectionPage(),
                routes: [
                  GoRoute(
                    path: ':pieceId',
                    builder: (_, state) => PieceDetailPage(
                      pieceId: state.pathParameters['pieceId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (_, _) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen<bool>(isSignedInProvider, (_, _) => notifyListeners());
  }
}
