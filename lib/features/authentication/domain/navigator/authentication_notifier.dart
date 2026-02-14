import 'package:flutter/material.dart';
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

  @override
  AuthenticationStatus build() {
    return const AuthenticationStatus.unknown();
  }

  Future<String?> redirect({
    required GoRouterState goRouterState,
    required List<String> publicRoutes,
  }) async {
    // Auth redirection is intentionally disabled until auth flow is completed.
    // Parameters are used here to keep the intent explicit and avoid dead code.
    if (publicRoutes.any(goRouterState.uri.path.startsWith)) {
      return null;
    }

    // final token = await ref
    //     .read(authenticationLocalDatasourceProvider)
    //     .getAuthUserToken();
    //
    // if ((token == null || state is AuthenticationStatusUnauthenticated) &&
    //     !isExcluded) {
    //   return RouteNames.signIn;
    // }
    //
    // if (publicRoutes.any(currentRoute.startsWith) &&
    //     token != null &&
    //     !isExcluded) {
    //   return RouteNames.home;
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
