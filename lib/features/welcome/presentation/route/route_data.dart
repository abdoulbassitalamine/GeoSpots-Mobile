import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/route_names.dart';
import '../welcome_page.dart';

part 'route_data.g.dart';

final welcomeMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'authentication',
);

@TypedGoRoute<WelcomeRouteData>(
  path: RouteNames.welcome,
  name: RouteNames.welcomeName,
)
class WelcomeRouteData extends GoRouteData with $WelcomeRouteData {
  const WelcomeRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: WelcomePage());
  }
}

final welcomeRoutesProvider = Provider<List<RouteBase>>((ref) => $appRoutes);
