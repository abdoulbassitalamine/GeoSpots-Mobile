import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/route_names.dart';
import '../collections/collections_page.dart';

part 'route_data.g.dart';

final collectionsMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'collections',
);

@TypedGoRoute<CollectionsRouteData>(
  path: RouteNames.collections,
  name: RouteNames.collectionsName,
)
class CollectionsRouteData extends GoRouteData with $CollectionsRouteData {
  const CollectionsRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: CollectionsPage());
  }
}

final collectionsRoutesProvider = Provider<RouteBase>((ref) => $appRoutes.first);
