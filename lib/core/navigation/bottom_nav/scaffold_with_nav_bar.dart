import 'package:flutter/material.dart';
import 'package:geo_spots/core/navigation/bottom_nav/utils/main_menu_extension.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'main_menu_key.dart';

class ScaffoldWithNavBar extends HookConsumerWidget {
  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationStatus = ref.watch(authenticationNotifierProvider);
    final isAuthenticated =
        authenticationStatus is AuthenticationStatusAuthenticated;
    final visibleMenus = isAuthenticated
        ? MainMenuKey.values
        : const [
            MainMenuKey.map,
            MainMenuKey.collections,
            MainMenuKey.profile,
          ];
    final selectedIndex = visibleMenus.indexWhere(
      (key) => _branchIndexFor(key) == navigationShell.currentIndex,
    );
    final safeSelectedIndex = selectedIndex >= 0 ? selectedIndex : 0;

    return Scaffold(
      backgroundColor: GSColorTokens.backgroundPrimary,
      body: navigationShell,
      bottomNavigationBar: visibleMenus.length >= 2
          ? Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                color: GSColorTokens.navBarBackground,
                child: SafeArea(
                  top: false,
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
                    items: visibleMenus
                        .map((key) => key.toBottomNavItem(context))
                        .toList(),
                    onTap: (index) => _goToLocation(visibleMenus[index]),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  int _branchIndexFor(MainMenuKey key) {
    return switch (key) {
      MainMenuKey.home => 0,
      MainMenuKey.map => 1,
      MainMenuKey.collections => 2,
      MainMenuKey.profile => 3,
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
