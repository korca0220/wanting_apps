import 'package:daily_piece/app/app.dart';
import 'package:daily_piece/core/auth/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('signed-out start lands on Sign in', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DailyPieceApp()));
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsWidgets);
  });

  testWidgets('signed-in start lands on Today', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authProvider.overrideWith((ref) => const AuthState(isSignedIn: true)),
        ],
        child: const DailyPieceApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsWidgets);
  });
}
