import 'package:geo_spots/core/utils/result/result.dart';
import 'package:geo_spots/shared/design_system/widgets/snackbar/snackbar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/use_case/places_use_cases.dart';
import 'places_list_state.dart';

part 'places_list_view_model.g.dart';

@riverpod
class PlacesListViewModel extends _$PlacesListViewModel {
  @override
  PlacesListState build() {
    ref.watch(getAllPlacesUseCaseProvider);
    Future.microtask(loadPlaces);
    return const PlacesListState();
  }

  Future<void> loadPlaces({String? tag}) async {
    state = state.copyWith(
      isLoading: true,
      selectedTag: tag,
      errorMessage: null,
    );

    final getAllPlaces = ref.read(getAllPlacesUseCaseProvider);
    final getPlacesByTag = ref.read(getPlacesByTagUseCaseProvider);
    final result = tag != null
        ? await getPlacesByTag(tag)
        : await getAllPlaces();

    switch (result) {
      case Ok(value: final places):
        state = state.copyWith(places: places, isLoading: false);
      case Err():
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Erreur lors du chargement des lieux',
          snackbarMessage: const GSSnackbarMessage(
            message: 'Erreur lors du chargement des lieux',
            type: GSSnackbarType.error,
          ),
        );
    }
  }

  Future<void> searchPlaces(String query) async {
    state = state.copyWith(searchQuery: query, isLoading: true);

    final searchPlaces = ref.read(searchPlacesUseCaseProvider);
    final result = await searchPlaces(query);

    switch (result) {
      case Ok(value: final places):
        state = state.copyWith(
          places: places,
          isLoading: false,
          errorMessage: null,
        );
      case Err():
        state = state.copyWith(
          isLoading: false,
          snackbarMessage: const GSSnackbarMessage(
            message: 'Erreur lors de la recherche',
            type: GSSnackbarType.error,
          ),
        );
    }
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    loadPlaces(tag: state.selectedTag);
  }

  Future<void> reload() => loadPlaces(tag: state.selectedTag);

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(errorMessage: null);
    }
  }

  void consumeSnackbar() {
    if (state.snackbarMessage != null) {
      state = state.copyWith(snackbarMessage: null);
    }
  }
}
