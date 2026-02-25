import 'package:geo_spots/features/collections/presentation/view_model/collections_view_model.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repository/places_repository.dart';
import 'place_details_state.dart';

part 'place_details_view_model.g.dart';

@riverpod
class PlaceDetailsViewModel extends _$PlaceDetailsViewModel {
  @override
  PlaceDetailsState build(String placeId) {
    Future.microtask(() => loadPlace(placeId));
    return const PlaceDetailsState(isLoading: true);
  }

  Future<void> loadPlace(String placeId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final repository = ref.read(placesRepositoryProvider);
      var place = await repository.getPlaceById(placeId);

      place ??= _findPlaceInCollections(placeId);

      if (place == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Lieu non trouvé',
        );
        return;
      }

      state = state.copyWith(place: place, isLoading: false);
    } on Exception {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement du lieu',
      );
    }
  }

  Future<void> deletePlace() async {
    if (state.place == null) return;

    try {
      // TODO(dev): Implement deletion.
      // final repository = ref.read(placesRepositoryProvider);
      // await repository.deletePlace(state.place!.id);
    } on Exception {
      state = state.copyWith(
        errorMessage: 'Erreur lors de la suppression',
      );
    }
  }

  PlaceEntity? _findPlaceInCollections(String placeId) {
    final collectionsState = ref.read(collectionsViewModelProvider);
    for (final collection in collectionsState.sharedCollections) {
      for (final sharedPlace in collection.places) {
        if (sharedPlace.id == placeId) {
          return sharedPlace;
        }
      }
    }
    return null;
  }
}
