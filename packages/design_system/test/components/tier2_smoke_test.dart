import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: WdsTheme.light(),
  home: Scaffold(body: child),
);

void main() {
  testWidgets('WdsChip toggles via onTap and reflects active styling', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        Center(
          child: WdsChip(label: 'Filter', active: true, onTap: () => taps++),
        ),
      ),
    );
    expect(find.text('Filter'), findsOneWidget);
    await tester.tap(find.byType(WdsChip));
    expect(taps, 1);
  });

  testWidgets('WdsBottomNavigation reports tap index', (tester) async {
    int? lastTap;
    await tester.pumpWidget(
      _wrap(
        Align(
          alignment: Alignment.bottomCenter,
          child: WdsBottomNavigation(
            currentIndex: 0,
            onTap: (i) => lastTap = i,
            items: const [
              WdsBottomNavigationItem(icon: Icon(Icons.home), label: 'Home'),
              WdsBottomNavigationItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              WdsBottomNavigationItem(icon: Icon(Icons.person), label: 'Me'),
            ],
          ),
        ),
      ),
    );
    expect(find.text('Home'), findsOneWidget);
    await tester.tap(find.text('Search'));
    expect(lastTap, 1);
  });

  testWidgets('WdsListItem renders title/caption and fires onTap', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        WdsListItem(
          leading: const Icon(Icons.settings),
          content: const WdsListItemContent(
            title: WdsListItemTitle('Notifications'),
            caption: WdsListItemCaption('Push, email, SMS'),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => taps++,
        ),
      ),
    );
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Push, email, SMS'), findsOneWidget);
    await tester.tap(find.byType(WdsListItem));
    expect(taps, 1);
  });

  testWidgets('WdsTopNavigation renders title widget', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const Align(
          alignment: Alignment.topCenter,
          child: WdsTopNavigation(title: Text('Settings')),
        ),
      ),
    );
    expect(find.text('Settings'), findsOneWidget);
  });

  testWidgets('WdsTabs underline reports selection change', (tester) async {
    String value = 'a';
    await tester.pumpWidget(
      MaterialApp(
        theme: WdsTheme.light(),
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) {
              return WdsTabs<String>(
                value: value,
                onChanged: (v) => setState(() => value = v),
                tabs: const [
                  WdsTabItem(value: 'a', label: 'One'),
                  WdsTabItem(value: 'b', label: 'Two'),
                ],
              );
            },
          ),
        ),
      ),
    );
    expect(find.text('One'), findsOneWidget);
    await tester.tap(find.text('Two'));
    await tester.pump();
    expect(value, 'b');
  });

  testWidgets('WdsImageUploader empty mode shows hint and fires onTap', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        Center(
          child: SizedBox(
            width: 200,
            child: WdsImageUploader(onTap: () => taps++, hint: 'Choose photo'),
          ),
        ),
      ),
    );
    expect(find.text('Choose photo'), findsOneWidget);
    await tester.tap(find.byType(WdsImageUploader));
    expect(taps, 1);
  });
}
