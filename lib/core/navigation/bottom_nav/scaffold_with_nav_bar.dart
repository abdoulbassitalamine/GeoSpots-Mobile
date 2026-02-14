import 'package:flutter/material.dart';
import 'package:geo_spots/core/navigation/bottom_nav/utils/main_menu_extension.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main_menu_key.dart';

class ScaffoldWithNavBar extends HookConsumerWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = navigationShell.currentIndex >= 0 &&
            navigationShell.currentIndex < MainMenuKey.values.length
        ? navigationShell.currentIndex
        : 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: GSColorTokens.backgroundPrimary,
        body: navigationShell,
        bottomNavigationBar: MainMenuKey.values.length >= 2
            ? Theme(
                data: Theme.of(context).copyWith(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: BottomNavigationBar(
                  currentIndex: selectedIndex,
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: GSColorTokens.navBarBackground,
                  selectedItemColor: GSColorTokens.navBarItemSelected,
                  unselectedItemColor: GSColorTokens.navBarItemDefault,
                  selectedLabelStyle: context.captionAccent,
                  unselectedLabelStyle: context.captionDefault,
                  showUnselectedLabels: true,
                  iconSize: 24,
                  items: MainMenuKey.values
                      .map((key) => key.toBottomNavItem(context))
                      .toList(),
                  onTap: (index) => _goToLocation(context, index),
                ),
              )
            : null,
      ),
    );
  }

  void _goToLocation(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
