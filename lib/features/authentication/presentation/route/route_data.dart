import 'package:flutter/material.dart';
import 'package:geo_spots/core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/design_system/widgets/common/gs_page_transition.dart';
import '../sign_in/sign_in_page.dart';
import '../sign_up/sign_up_page.dart';

final authenticationMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'authentication',
);
final authenticationRoutesProvider = Provider(
  (ref) => [
    GoRoute(
      path: RouteNames.signIn,
      name: RouteNames.signIn,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: SignInPage());
      },
    ),
    GoRoute(
      path: RouteNames.signUp,
      name: RouteNames.signUp,
      pageBuilder: (context, state) => GSPageTransition.buildTransition(
        type: GSPageTransitionType.slideRight,
        child: SignUpPage(),
      ),
    ),
  ],
);
