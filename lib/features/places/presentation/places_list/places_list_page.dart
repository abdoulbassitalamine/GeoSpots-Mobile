import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/route_names.dart';
import '../../../../shared/design_system/widgets/scaffold/gs_scaffold.dart';
import 'view/places_list_view.dart';

class PlacesListPage extends StatelessWidget {
  const PlacesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GSScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(
          RouteNames.upsertPlaceName,
          pathParameters: {RouteNames.placeIdParam: 'new'},
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nouveau lieu'),
      ),
      body: PlacesListView(),
    );
  }
}
