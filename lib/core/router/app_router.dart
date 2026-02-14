import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geo_spots/core/router/route_names.dart';
import 'package:geo_spots/features/collections/presentation/route/route_data.dart';
import 'package:geo_spots/features/home/presentation/route/route_data.dart';
import 'package:geo_spots/features/map/presentation/route/route_data.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:geo_spots/features/settings/presentation/route/route_data.dart';
import 'package:geo_spots/features/welcome/presentation/route/route_data.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/authentication/domain/navigator/authentication_notifier.dart';
import '../../features/authentication/presentation/route/route_data.dart';
import '../navigation/bottom_nav/scaffold_with_nav_bar.dart';
import '../route_utils/route/router.dart';

part 'app_router.g.dart';

const _restorationScopeId = 'restorationScopeId';

const _publicRoutes = [
  RouteNames.welcome,
  RouteNames.signIn,
  RouteNames.signUp,
  RouteNames.forgotPassword,
];

@TypedStatefulShellRoute<MainShellRouteData>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRouteData>(
          path: RouteNames.home,
          name: RouteNames.homeName,
        ),
      ],
    ),
    TypedStatefulShellBranch<MapShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<MapRouteData>(
          path: RouteNames.map,
          name: RouteNames.mapName,
        ),
      ],
    ),
    TypedStatefulShellBranch<CollectionsShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<CollectionsRouteData>(
          path: RouteNames.collections,
          name: RouteNames.collectionsName,
        ),
      ],
    ),
    TypedStatefulShellBranch<SettingsShellBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SettingsRouteData>(
          path: RouteNames.settings,
          name: RouteNames.settingsName,
        ),
      ],
    ),
  ],
)
class MainShellRouteData extends StatefulShellRouteData {
  const MainShellRouteData();

  static const String $restorationScopeId = _restorationScopeId;

  @override
  Page<void> pageBuilder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return NoTransitionPage(
      child: ScaffoldWithNavBar(navigationShell: navigationShell),
    );
  }
}

class HomeShellBranchData extends StatefulShellBranchData {
  const HomeShellBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = homeMainNavigatorKey;
}

class MapShellBranchData extends StatefulShellBranchData {
  const MapShellBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey = mapMainNavigatorKey;
}

class CollectionsShellBranchData extends StatefulShellBranchData {
  const CollectionsShellBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey =
      collectionsMainNavigatorKey;
}

class SettingsShellBranchData extends StatefulShellBranchData {
  const SettingsShellBranchData();

  static final GlobalKey<NavigatorState> $navigatorKey =
      settingsMainNavigatorKey;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authenticationNotifier = ref.watch(
    authenticationNotifierProvider.notifier,
  );

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: !kReleaseMode,
    initialLocation: RouteNames.welcome,
    observers: [],
    refreshListenable: Listenable.merge([authenticationNotifier]),
    redirect: (context, state) async {
      final authRedirect = await authenticationNotifier.redirect(
        goRouterState: state,
        publicRoutes: _publicRoutes,
      );

      return authRedirect;
    },
    routes: [
      ...ref.read(welcomeRoutesProvider),

      // Authentication routes
      ...ref.read(authenticationRoutesProvider),

      ...ref.read(placesRoutesProvider),

      ...$appRoutes,
    ],
  );

  ref.onDispose(router.dispose);

  return router;
}

final routeInformationProvider = Provider<GoRouteInformationProvider>((ref) {
  final router = ref.watch(appRouterProvider);
  return router.routeInformationProvider;
});

final currentRouteProvider = Provider(
  (ref) => ref.watch(routeInformationProvider).value.uri,
);
