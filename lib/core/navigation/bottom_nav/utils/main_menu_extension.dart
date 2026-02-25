import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/tokens/color_tokens.dart';

import '../../../../gen/assets.gen.dart';
import '../../../router/route_names.dart';
import '../main_menu_key.dart';

extension MainMenuExtension on MainMenuKey {
  String get path {
    return switch (this) {
      MainMenuKey.map => RouteNames.map,
      MainMenuKey.collections => RouteNames.collections,
      MainMenuKey.profile => RouteNames.settings,
    };
  }

  BottomNavigationBarItem toBottomNavItem(BuildContext context) {
    return switch (this) {
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
}
