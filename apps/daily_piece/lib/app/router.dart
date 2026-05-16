import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/session_provider.dart';
import '../features/auth/presentation/pages/reset_password_page.dart';
import '../features/auth/presentation/pages/sign_in_page.dart';
import '../features/auth/presentation/pages/sign_up_page.dart';
import '../features/calendar/presentation/pages/calendar_page.dart';
import '../features/edit_piece/presentation/pages/edit_piece_page.dart';
import '../features/my_pieces/presentation/pages/my_pieces_page.dart';
import '../features/piece_detail/presentation/pages/piece_detail_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/search/presentation/pages/search_page.dart';
import '../features/welcome/presentation/pages/welcome_page.dart';
import 'shell/main_shell_page.dart';

const _publicPaths = {'/welcome', '/sign-in', '/sign-up', '/reset-password'};

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/my-pieces',
    redirect: (context, state) {
      final signedIn = ref.read(isSignedInProvider);
      final atPublic = _publicPaths.contains(state.matchedLocation);

      if (!signedIn && !atPublic) return '/welcome';
      if (signedIn && atPublic) return '/my-pieces';
      return null;
    },
    refreshListenable: _RouterRefresh(ref),
    routes: [
      GoRoute(path: '/welcome', builder: (_, _) => const WelcomePage()),
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/sign-up', builder: (_, _) => const SignUpPage()),
      GoRoute(
        path: '/reset-password',
        builder: (_, _) => const ResetPasswordPage(),
      ),
      // Global detail routes that should not force a tab switch.
      GoRoute(
        path: '/piece/:pieceId',
        builder: (_, state) =>
            PieceDetailPage(pieceId: state.pathParameters['pieceId']!),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (_, state) =>
                EditPiecePage(pieceId: state.pathParameters['pieceId']!),
          ),
        ],
      ),
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
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (_, state) => EditPiecePage(
                          pieceId: state.pathParameters['pieceId']!,
                        ),
                      ),
                    ],
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
