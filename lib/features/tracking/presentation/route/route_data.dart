import 'package:flutter/material.dart';
import 'package:geo_spots/core/route_utils/route/router.dart';
import 'package:geo_spots/core/router/route_names.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../views/live_location_viewer_screen.dart';

part 'route_data.g.dart';

@TypedGoRoute<LiveLocationRouteData>(
  path: RouteNames.liveLocation,
  name: RouteNames.liveLocationName,
)
class LiveLocationRouteData extends GoRouteData with $LiveLocationRouteData {
  const LiveLocationRouteData({required this.token});

  static final GlobalKey<NavigatorState> $parentNavigatorKey = rootNavigatorKey;

  final String token;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return GSPageTransition.buildTransition(
      type: GSPageTransitionType.slideUp,
      child: LiveLocationViewerScreen(token: token),
    );
  }
}

final trackingRoutesProvider = Provider<List<RouteBase>>((ref) => $appRoutes);
