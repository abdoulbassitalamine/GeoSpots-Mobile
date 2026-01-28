import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geo_spots/core/router/route_names.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:geo_spots/features/welcome/presentation/route/route_data.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/authentication/domain/navigator/authentication_notifier.dart';
import '../../features/authentication/presentation/route/route_data.dart';
import '../navigation/bottom_nav/main_menu_key.dart';
import '../navigation/bottom_nav/scaffold_with_nav_bar.dart';
import '../navigation/bottom_nav/utils/main_menu_extension.dart';
import '../route_utils/extension/go_route_extension.dart';
import '../route_utils/route/router.dart';

part 'app_router.g.dart';

const _restorationScopeId = 'restorationScopeId';

const _publicRoutes = [
  RouteNames.welcome,
  RouteNames.signIn,
  RouteNames.signUp,
  RouteNames.forgotPassword,
];

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authenticationNotifier = ref.watch(
    authenticationNotifierProvider.notifier,
  );

  final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: !kReleaseMode,
    initialLocation: RouteNames.home,
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

      // Main app shell with bottom navigation
      StatefulShellRoute.indexedStack(
        restorationScopeId: _restorationScopeId,
        pageBuilder: (context, state, navigationShell) {
          if (state.topRoute?.withAppBar ?? true) {
            return NoTransitionPage(
              child: ScaffoldWithNavBar(navigationShell: navigationShell),
            );
          }
          return NoTransitionPage(
            child: SafeArea(child: Scaffold(body: navigationShell)),
          );
        },
        branches: MainMenuKey.values
            .map((key) => key.toShellBranch(ref, _restorationScopeId))
            .toList(),
      ),
    ],
  );

  ref.onDispose(router.dispose);

  return router;
}

final routeInformationProvider =
    ChangeNotifierProvider<GoRouteInformationProvider>((ref) {
      final router = ref.watch(appRouterProvider);
      return router.routeInformationProvider;
    });

final currentRouteProvider = Provider(
  (ref) => ref.watch(routeInformationProvider).value.uri,
);
