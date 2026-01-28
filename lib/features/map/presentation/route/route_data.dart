import 'package:geo_spots/core/router/route_names.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../map/map_page.dart';

final mapMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'map',
);
final mapRoutesProvider = Provider(
  (ref) =>  GoRoute(
      path: RouteNames.map,
      name: RouteNames.mapName,
      pageBuilder: (context, state) {
        return const NoTransitionPage(child: MapPage());
      },
    ),

);
