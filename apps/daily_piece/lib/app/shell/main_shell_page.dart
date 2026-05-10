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
            icon: Icon(Icons.photo_library_outlined),
            activeIcon: Icon(Icons.photo_library),
            label: 'My Pieces',
          ),
          WdsBottomNavigationItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          WdsBottomNavigationItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          WdsBottomNavigationItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
