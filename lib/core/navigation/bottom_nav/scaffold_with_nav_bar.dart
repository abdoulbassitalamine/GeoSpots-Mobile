import 'package:flutter/material.dart';
import 'package:geo_spots/core/navigation/bottom_nav/utils/main_menu_extension.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main_menu_key.dart';

const _gsNavigationBarDefaultHeight = GSSpacing.$900;

class ScaffoldWithNavBar extends HookConsumerWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = MainMenuKey.values.indexWhere(
      (key) => _branchIndexFor(key) == navigationShell.currentIndex,
    );
    final safeSelectedIndex = selectedIndex >= 0 ? selectedIndex : 0;

    return Scaffold(
      backgroundColor: GSColorTokens.backgroundPrimary,
      body: navigationShell,
      bottomNavigationBar: MainMenuKey.values.length >= 2
          ? Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: ColoredBox(
                color: GSColorTokens.navBarBackground,
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: _gsNavigationBarDefaultHeight,
                    child: BottomNavigationBar(
                      currentIndex: safeSelectedIndex,
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
                      onTap: (index) => _goToLocation(MainMenuKey.values[index]),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  int _branchIndexFor(MainMenuKey key) {
    return switch (key) {
      MainMenuKey.map => 0,
      MainMenuKey.collections => 1,
      MainMenuKey.profile => 2,
    };
  }

  void _goToLocation(MainMenuKey key) {
    final branchIndex = _branchIndexFor(key);
    navigationShell.goBranch(
      branchIndex,
      initialLocation: branchIndex == navigationShell.currentIndex,
    );
  }
}
