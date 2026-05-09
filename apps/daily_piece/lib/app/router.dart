import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/auth/session_provider.dart';
import '../features/auth/sign_in_page.dart';
import '../features/collection/collection_page.dart';
import '../features/piece_detail/piece_detail_page.dart';
import '../features/settings/settings_page.dart';
import '../features/today/today_page.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/today',
    redirect: (context, state) {
      final signedIn = ref.read(isSignedInProvider);
      final atSignIn = state.matchedLocation == '/sign-in';
      if (!signedIn && !atSignIn) return '/sign-in';
      if (signedIn && atSignIn) return '/today';
      return null;
    },
    refreshListenable: _RouterRefresh(ref),
    routes: [
      GoRoute(path: '/sign-in', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/today', builder: (_, _) => const TodayPage()),
      GoRoute(path: '/collection', builder: (_, _) => const CollectionPage()),
      GoRoute(
        path: '/collection/:pieceId',
        builder: (_, state) =>
            PieceDetailPage(pieceId: state.pathParameters['pieceId']!),
      ),
      GoRoute(path: '/settings', builder: (_, _) => const SettingsPage()),
    ],
  );
});

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    ref.listen<bool>(isSignedInProvider, (_, _) => notifyListeners());
  }
}
