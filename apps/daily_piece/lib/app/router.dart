import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/session_provider.dart';
import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import '../features/calendar/presentation/pages/calendar_page.dart';
import '../features/my_pieces/presentation/pages/my_pieces_page.dart';
import '../features/piece_detail/presentation/pages/piece_detail_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/search/presentation/pages/search_page.dart';
import 'shell/main_shell_page.dart';

const _authPaths = {'/sign-in', '/sign-up'};

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/my-pieces',
    redirect: (context, state) {
      final signedIn = ref.read(isSignedInProvider);
      final atAuth = _authPaths.contains(state.matchedLocation);

      if (!signedIn && !atAuth) return '/sign-in';
      if (signedIn && atAuth) return '/my-pieces';
      return null;
    },
    refreshListenable: _RouterRefresh(ref),
    routes: [
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (_, _) => const SignUpPage()),
      // Bottom-nav shell. Each branch keeps its own navigator so deep links
      // into a tab (e.g. /my-pieces/:pieceId) keep their back stack when the
      // user switches tabs and comes back.
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShellPage(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/my-pieces',
                builder: (_, _) => const MyPiecesPage(),
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
                path: '/calendar',
                builder: (_, _) => const CalendarPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/search', builder: (_, _) => const SearchPage()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, _) => const ProfilePage(),
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
