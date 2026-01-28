import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/route_names.dart';
import '../../add_place/add_place_page.dart';
import '../places_list/places_list_page.dart';
import '../place_details/place_details_page.dart';

final placesMainNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'places');

final placesRoutesProvider = Provider(
      (ref) => [
    GoRoute(
      path: RouteNames.places,
      name: RouteNames.placesName,
      pageBuilder: (context, state) {
        return GSPageTransition.buildTransition(child: PlacesListPage());
      },
      routes: [
        GoRoute(
          path: RouteNames.addPlace,
          name: RouteNames.addPlaceName,
          pageBuilder: (context, state) {
            return GSPageTransition.buildTransition(
              child: const AddPlacePage(),
            );
          },
        ),
        GoRoute(
          path: ':${RouteNames.placeIdParam}',
          name: RouteNames.placeDetailsName,
          pageBuilder: (context, state) {
            final placeId = state.pathParameters[RouteNames.placeIdParam]!;
            return GSPageTransition.buildTransition(
              child: PlaceDetailsPage(placeId: placeId),
            );
          },
        ),
      ],
    ),
  ],
);