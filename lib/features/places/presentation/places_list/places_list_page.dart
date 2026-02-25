import 'package:flutter/material.dart';
import 'package:geo_spots/core/constants/app_constants.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import '../../../../shared/design_system/widgets/scaffold/gs_scaffold.dart';
import 'view/places_list_view.dart';

class PlacesListPage extends StatelessWidget {
  const PlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GSScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            UpsertPlaceRouteData(placeId: kPlaceCreationId).push<void>(context),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau lieu'),
      ),
      body: PlacesListView(),
    );
  }
}
