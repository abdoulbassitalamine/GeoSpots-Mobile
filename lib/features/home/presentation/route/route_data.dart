import 'package:geo_spots/core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../home/home_page.dart';

part 'route_data.g.dart';

final homeMainNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');

@TypedGoRoute<HomeRouteData>(
  path: RouteNames.home,
  name: RouteNames.homeName,
)
class HomeRouteData extends GoRouteData with $HomeRouteData {
  const HomeRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: HomePage());
  }
}

final homeRoutesProvider = Provider<RouteBase>((ref) => $appRoutes.first);
