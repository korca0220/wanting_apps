import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Hosts the bottom-tab navigation. `navigationShell` is the indexed stack of
/// per-tab navigators provided by `StatefulShellRoute.indexedStack`; tapping a
/// tab calls `goBranch`, which preserves each branch's back stack so you can
/// pop back into a sub-route after switching tabs and back.
class MainShellPage extends StatelessWidget {
  const MainShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: WdsBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (i) => navigationShell.goBranch(
          i,
          // Re-tapping the active tab pops to its branch root, matching the
          // platform expectation for tab bars.
          initialLocation: i == navigationShell.currentIndex,
        ),
        items: const [
          WdsBottomNavigationItem(
            icon: Icon(Icons.today_outlined),
            activeIcon: Icon(Icons.today),
            label: '오늘',
          ),
          WdsBottomNavigationItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: '컬렉션',
          ),
          WdsBottomNavigationItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '설정',
          ),
        ],
      ),
    );
  }
}
