import 'package:geo_spots/core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../map/map_page.dart';

part 'route_data.g.dart';

final mapMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'map',
);

@TypedGoRoute<MapRouteData>(
  path: RouteNames.map,
  name: RouteNames.mapName,
)
class MapRouteData extends GoRouteData with $MapRouteData {
  const MapRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: MapPage());
  }
}

final mapRoutesProvider = Provider<RouteBase>((ref) => $appRoutes.first);
