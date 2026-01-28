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
      final place = await repository.getPlaceById(placeId);

      if (place == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Lieu non trouvé',
        );
        return;
      }

      state = state.copyWith(place: place, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement du lieu',
      );
    }
  }

  Future<void> deletePlace() async {
    if (state.place == null) return;

    try {
      // TODO: Implémenter la suppression
      // final repository = ref.read(placesRepositoryProvider);
      // await repository.deletePlace(state.place!.id);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Erreur lors de la suppression',
      );
    }
  }
}