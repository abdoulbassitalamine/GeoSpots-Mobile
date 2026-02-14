import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/authentication.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import 'package:geo_spots/features/home/presentation/route/route_data.dart';
import 'package:geo_spots/features/map/presentation/route/route_data.dart';
import 'package:geo_spots/features/welcome/presentation/route/route_data.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/authentication_status/authentication_status.dart';

final authenticationNotifierProvider =
    NotifierProvider<AuthenticationNotifier, AuthenticationStatus>(
      AuthenticationNotifier.new,
    );

class AuthenticationNotifier extends Notifier<AuthenticationStatus>
    implements Listenable {
  static final _excludedRoutes = [
    SignInRouteData().location,
    SignUpRouteData().location,
    ForgotPasswordRouteData().location,
    WelcomeRouteData().location,
  ];

  VoidCallback? _routerListener;

  @override
  AuthenticationStatus build() {
    return const AuthenticationStatus.unknown();
  }

  Future<String?> redirect({
    required GoRouterState goRouterState,
    required List<String> publicRoutes,
  }) async {
    final currentRoute = goRouterState.uri.toString();
    final isExcludedRoute = _excludedRoutes.contains(currentRoute);

    if (publicRoutes.any(goRouterState.uri.path.startsWith)) {
      return null;
    }

    final token = await ref
        .read(authenticationLocalDatasourceProvider)
        .getAuthUserToken();

    if ((token == null || state is AuthenticationStatusUnauthenticated) &&
        !isExcludedRoute &&
        currentRoute == HomeRouteData().location) {
      return MapRouteData().location;
    }

    if (publicRoutes.any(currentRoute.startsWith) &&
        token != null &&
        !isExcludedRoute) {
      return HomeRouteData().location;
    }

    return null;
  }

  void updateState(AuthenticationStatus status) {
    state = status;
    _routerListener?.call();
  }

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  void removeListener(VoidCallback listener) => _routerListener = null;
}
