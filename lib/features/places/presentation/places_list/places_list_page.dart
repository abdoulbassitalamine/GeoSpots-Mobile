import 'package:flutter/material.dart';
import 'package:geo_spots/core/constants/app_constants.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../shared/design_system/widgets/scaffold/gs_scaffold.dart';
import '../view_model/places_list_view_model.dart';
import 'view/places_list_view.dart';

class PlacesListPage extends ConsumerWidget {
  const PlacesListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GSScaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await UpsertPlaceRouteData(
            placeId: kPlaceCreationId,
          ).push<bool>(context);
          if (created ?? false) {
            await ref.read(placesListViewModelProvider.notifier).reload();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Nouveau lieu'),
      ),
      body: PlacesListView(),
    );
  }
}
