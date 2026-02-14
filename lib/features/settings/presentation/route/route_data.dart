import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';

import '../../../../core/router/route_names.dart';
import '../settings/settings_page.dart';

part 'route_data.g.dart';

final settingsMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'settings',
);

@TypedGoRoute<SettingsRouteData>(
  path: RouteNames.settings,
  name: RouteNames.settingsName,
)
class SettingsRouteData extends GoRouteData with $SettingsRouteData {
  const SettingsRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: SettingsPage());
  }
}

final settingsRoutesProvider = Provider<RouteBase>((ref) => $appRoutes.first);
