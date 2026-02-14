import 'package:flutter/material.dart';
import 'package:geo_spots/core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/design_system/widgets/common/gs_page_transition.dart';
import '../sign_in/sign_in_page.dart';
import '../sign_up/sign_up_page.dart';

part 'route_data.g.dart';

final authenticationMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'authentication',
);

@TypedGoRoute<SignInRouteData>(
  path: RouteNames.signIn,
  name: RouteNames.signInName,
)
class SignInRouteData extends GoRouteData with $SignInRouteData {
  const SignInRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: SignInPage());
  }
}

@TypedGoRoute<SignUpRouteData>(
  path: RouteNames.signUp,
  name: RouteNames.signUpName,
)
class SignUpRouteData extends GoRouteData with $SignUpRouteData {
  const SignUpRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return GSPageTransition.buildTransition(
      type: GSPageTransitionType.slideRight,
      child: SignUpPage(),
    );
  }
}

@TypedGoRoute<ForgotPasswordRouteData>(
  path: RouteNames.forgotPassword,
  name: RouteNames.forgotPasswordName,
)
class ForgotPasswordRouteData extends GoRouteData with $ForgotPasswordRouteData {
  const ForgotPasswordRouteData();

  @override
  String? redirect(BuildContext context, GoRouterState state) {
    return const SignInRouteData().location;
  }
}

final authenticationRoutesProvider =
    Provider<List<RouteBase>>((ref) => $appRoutes);
