import 'package:flutter/material.dart';
import 'package:geo_spots/features/places/presentation/upsert_place/upsert_place_page.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/router/route_names.dart';
import '../place_details/place_details_page.dart';
import '../places_list/places_list_page.dart';

part 'route_data.g.dart';

final placesMainNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'places');

@TypedGoRoute<PlacesRouteData>(
  path: RouteNames.places,
  name: RouteNames.placesName,
  routes: <TypedRoute<RouteData>>[
    TypedGoRoute<UpsertPlaceRouteData>(
      path: '${RouteNames.upsertPlace}/:${RouteNames.placeIdParam}',
      name: RouteNames.upsertPlaceName,
    ),
    TypedGoRoute<PlaceDetailsRouteData>(
      path: ':${RouteNames.placeIdParam}',
      name: RouteNames.placeDetailsName,
    ),
  ],
)
class PlacesRouteData extends GoRouteData with $PlacesRouteData {
  const PlacesRouteData();

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return GSPageTransition.buildTransition(child: PlacesListPage());
  }
}

class UpsertPlaceRouteData extends GoRouteData with $UpsertPlaceRouteData {
  const UpsertPlaceRouteData({required this.placeId, this.$extra});

  final String placeId;
  final Map<String, Object?>? $extra;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return GSPageTransition.buildTransition(
      child: UpsertPlacePage(
        placeId: placeId,
        initialExtra: state.extra as Map<String, Object?>?,
      ),
    );
  }
}

class PlaceDetailsRouteData extends GoRouteData with $PlaceDetailsRouteData {
  const PlaceDetailsRouteData({required this.placeId});

  final String placeId;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return GSPageTransition.buildTransition(
      child: PlaceDetailsPage(placeId: placeId),
    );
  }
}

final placesRoutesProvider = Provider<List<RouteBase>>((ref) => $appRoutes);
