import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:flutter/material.dart';

import '../../../../core/router/route_names.dart';
import '../settings/settings_page.dart';

final settingsMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'settings',
);
final settingsRoutesProvider = Provider(
  (ref) => GoRoute(
    path: RouteNames.settings,
    name: RouteNames.settingsName,
    pageBuilder: (context, state) {
      return const NoTransitionPage(child: SettingsPage());
    },
  ),
);
