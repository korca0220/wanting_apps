import 'package:daily_piece/app/app.dart';
import 'package:daily_piece/core/auth/session_provider.dart';
import 'package:daily_piece/core/data/datasources/preferences_local_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('signed-out start lands on Welcome', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isSignedInProvider.overrideWithValue(false),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const DailyPieceApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Create Account'), findsWidgets);
    expect(find.text('Sign In'), findsWidgets);
  });

  testWidgets('signed-in start lands on My Pieces', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isSignedInProvider.overrideWithValue(true),
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const DailyPieceApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('DailyPiece'), findsWidgets);
  });
}
