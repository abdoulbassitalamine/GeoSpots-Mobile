import 'package:flutter/material.dart';
import 'package:geo_spots/core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../entity/authentication_status/authentication_status.dart';

final authenticationNotifierProvider =
    NotifierProvider<AuthenticationNotifier, AuthenticationStatus>(
      AuthenticationNotifier.new,
    );

class AuthenticationNotifier extends Notifier<AuthenticationStatus>
    implements Listenable {
  VoidCallback? _routerListener;

  static const List<String> _excludedRoutes = [
    RouteNames.forgotPassword,
    RouteNames.signIn,
    RouteNames.signUp,
    RouteNames.welcome,
  ];

  @override
  AuthenticationStatus build() {
    return const AuthenticationStatus.unknown();
  }

  bool _isExcludedRoute(String route) {
    return _excludedRoutes.contains(route);
  }

  Future<String?> redirect({
    required GoRouterState goRouterState,
    required List<String> publicRoutes,
  }) async {
    final currentRoute = goRouterState.uri.toString();
    final isExcluded = _isExcludedRoute(currentRoute);

    // final token = await ref
    //     .read(authenticationLocalDatasourceProvider)
    //     .getAuthUserToken();
    //
    // if ((token == null || state is AuthenticationStatusUnauthenticated) &&
    //     !isExcluded) {
    //   return kAuthLoginPath;
    // }
    //
    // if (publicRoutes.any(currentRoute.startsWith) &&
    //     token != null &&
    //     !isExcluded) {
    //   return kAuthHomePath;
    // }

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
