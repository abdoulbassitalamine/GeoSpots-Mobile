import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/route_names.dart';
import '../collection_details/collection_details_page.dart';
import '../collections/collections_page.dart';

part 'route_data.g.dart';

final collectionsMainNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'collections',
);

@TypedGoRoute<CollectionsRouteData>(
  path: RouteNames.collections,
  name: RouteNames.collectionsName,
  routes: [
    TypedGoRoute<CollectionDetailsRouteData>(
      path: RouteNames.collectionDetails,
      name: RouteNames.collectionDetailsName,
    ),
  ],
)
class CollectionsRouteData extends GoRouteData with $CollectionsRouteData {
  const CollectionsRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return const NoTransitionPage(child: CollectionsPage());
  }
}

class CollectionDetailsRouteData extends GoRouteData
    with $CollectionDetailsRouteData {
  const CollectionDetailsRouteData({required this.collectionTag});

  final String collectionTag;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return CollectionDetailsPage(collectionTag: collectionTag);
  }
}

final collectionsRoutesProvider = Provider<RouteBase>((ref) => $appRoutes.first);
