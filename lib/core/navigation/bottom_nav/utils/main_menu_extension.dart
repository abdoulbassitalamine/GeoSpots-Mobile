import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/presentation/route/route_data.dart';
import 'package:geo_spots/features/home/presentation/route/route_data.dart';
import 'package:geo_spots/features/map/presentation/route/route_data.dart';
import 'package:geo_spots/features/settings/presentation/route/route_data.dart';
import 'package:geo_spots/shared/design_system/tokens/color_tokens.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../gen/assets.gen.dart';
import '../../../router/route_names.dart';
import '../main_menu_key.dart';

extension MainMenuExtension on MainMenuKey {
  String get path {
    return switch (this) {
      MainMenuKey.home => RouteNames.home,
      MainMenuKey.map => RouteNames.map,
      MainMenuKey.collections => RouteNames.collections,
      MainMenuKey.profile => RouteNames.settings,
    };
  }

  BottomNavigationBarItem toBottomNavItem(BuildContext context) {
    return switch (this) {
      MainMenuKey.home => BottomNavigationBarItem(
        label: 'Home',
        icon: GSIcons.icons.home.svg(
          colorFilter: ColorFilter.mode(
            GSColorTokens.navBarItemDefault,
            BlendMode.srcIn,
          ),
        ),
        activeIcon: GSIcons.icons.home.svg(
          colorFilter: ColorFilter.mode(
            GSColorTokens.navBarItemSelected,
            BlendMode.srcIn,
          ),
        ),
      ),
      MainMenuKey.map => BottomNavigationBarItem(
        label: 'Carte',
        icon: GSIcons.icons.map.svg(
          colorFilter: ColorFilter.mode(
            GSColorTokens.navBarItemDefault,
            BlendMode.srcIn,
          ),
        ),
        activeIcon: GSIcons.icons.map.svg(
          colorFilter: ColorFilter.mode(
            GSColorTokens.navBarItemSelected,
            BlendMode.srcIn,
          ),
        ),
      ),
      MainMenuKey.collections => BottomNavigationBarItem(
        label: 'Collections',
        icon: GSIcons.icons.collections.svg(
          colorFilter: ColorFilter.mode(
            GSColorTokens.navBarItemDefault,
            BlendMode.srcIn,
          ),
        ),
        activeIcon: GSIcons.icons.collections.svg(
          colorFilter: ColorFilter.mode(
            GSColorTokens.navBarItemSelected,
            BlendMode.srcIn,
          ),
        ),
      ),
      MainMenuKey.profile => BottomNavigationBarItem(
        label: 'Profil',
        icon: GSIcons.icons.profile.svg(
          colorFilter: ColorFilter.mode(
            GSColorTokens.navBarItemDefault,
            BlendMode.srcIn,
          ),
        ),
        activeIcon: GSIcons.icons.profile.svg(
          colorFilter: ColorFilter.mode(
            GSColorTokens.navBarItemSelected,
            BlendMode.srcIn,
          ),
        ),
      ),
    };
  }

  StatefulShellBranch toShellBranch(Ref ref, String? restorationScopeId) {
    return switch (this) {
      MainMenuKey.home => StatefulShellBranch(
        navigatorKey: homeMainNavigatorKey,
        restorationScopeId: restorationScopeId,
        routes: <RouteBase>[ref.watch(homeRoutesProvider)],
      ),
      MainMenuKey.map => StatefulShellBranch(
        navigatorKey: mapMainNavigatorKey,
        restorationScopeId: restorationScopeId,
        routes: <RouteBase>[ref.watch(mapRoutesProvider)],
      ),
      MainMenuKey.collections => StatefulShellBranch(
        restorationScopeId: restorationScopeId,
        routes: <RouteBase>[ref.watch(collectionsRoutesProvider)],
      ),
      MainMenuKey.profile => StatefulShellBranch(
        navigatorKey: settingsMainNavigatorKey,
        restorationScopeId: restorationScopeId,
        routes: <RouteBase>[ref.watch(settingsRoutesProvider)],
      ),
    };
  }
}
