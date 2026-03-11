import 'package:flutter/material.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/features/places/presentation/route/route_data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/places_list_state.dart';
import '../../view_model/places_list_view_model.dart';
import '../widgets/place_list_item.dart';
import '../widgets/places_list_header.dart';
import '../widgets/places_search_bar.dart';

class PlacesListView extends ConsumerWidget {
  const PlacesListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      placesListViewModelProvider.select((state) => state.snackbarMessage),
      (previous, next) {
        if (next == null || previous == next) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }
          next.show(context);
          ref.read(placesListViewModelProvider.notifier).consumeSnackbar();
        });
      },
    );

    final state = ref.watch(placesListViewModelProvider);
    final viewModel = ref.read(placesListViewModelProvider.notifier);

    return Column(
      children: [
        PlacesListHeader(
          title: _getTitle(),
          subtitle: _getSubtitle(state.places.length),
        ),
        PlacesSearchBar(
          searchQuery: state.searchQuery,
          onSearchChanged: viewModel.searchPlaces,
          onClearSearch: viewModel.clearSearch,
        ),
        Expanded(child: _buildContent(context, state)),
      ],
    );
  }

  Widget _buildContent(BuildContext context, PlacesListState state) {
    if (state.isLoading) {
      return const Center(child: GSCircularLoader());
    }

    if (state.errorMessage != null && state.places.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(GSSpacing.xl3),
          child: Text(
            state.errorMessage!,
            style: GSTypography.bodyDefaultMedium.copyWith(
              color: GSColors.danger600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.places.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(GSSpacing.xl3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_off, size: 64, color: GSColors.neutral400),
              const SizedBox(height: GSSpacing.xl),
              Text(
                state.searchQuery.isNotEmpty
                    ? 'Aucun lieu trouvé pour "${state.searchQuery}"'
                    : 'Aucun lieu enregistré',
                style: GSTypography.bodyDefaultLarge.copyWith(
                  color: GSColors.neutral600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.xl,
        vertical: GSSpacing.xl,
      ),
      itemCount: state.places.length,
      separatorBuilder: (context, index) => const SizedBox(height: GSSpacing.l),
      itemBuilder: (context, index) {
        final place = state.places[index];
        GsLogger().d('place: $place');
        return PlaceListItem(
          place: place,
          onTap: () {
            PlaceDetailsRouteData(placeId: place.id).push<void>(context);
          },
        );
      },
    );
  }

  String _getTitle() {
    return 'Tous les lieux';
  }

  String _getSubtitle(int count) {
    return '$count ${count > 1 ? 'lieux' : 'lieu'}';
  }
}
