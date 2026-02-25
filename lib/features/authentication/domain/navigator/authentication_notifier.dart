import 'package:flutter/material.dart';
import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/features/authentication/authentication.dart';
import 'package:geo_spots/features/authentication/data/datasource/local_datasource/authentication/authentication_local_datasource.dart';
import 'package:geo_spots/features/map/presentation/route/route_data.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'authentication_notifier.g.dart';

@Riverpod(keepAlive: true)
class AuthGuardNotifier extends _$AuthGuardNotifier implements Listenable {
  static final _excludedRoutes = [
    SignInRouteData().location,
    SignUpRouteData().location,
    ForgotPasswordRouteData().location,
  ];

  VoidCallback? _routerListener;

  @override
  AuthenticationStatus build() {
    return const AuthenticationStatus.unknown();
  }

  Future<String?> redirect({
    required GoRouterState goRouterState,
  }) async {
    final currentPath = goRouterState.uri.path;
    final isExcludedRoute = _excludedRoutes.any(currentPath.startsWith);

    final tokenResult = await ref
        .read(authenticationLocalDatasourceProvider)
        .getAuthUserToken();

    final token = switch (tokenResult) {
      Ok(:final value) => value,
      Err() => null,
    };
    final hasToken = token != null && token.isNotEmpty;

    if (isExcludedRoute && hasToken) {
      return MapRouteData().location;
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
