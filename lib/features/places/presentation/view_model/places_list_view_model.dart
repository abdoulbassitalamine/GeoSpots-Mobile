import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repository/places_repository.dart';
import 'places_list_state.dart';

part 'places_list_view_model.g.dart';

@riverpod
class PlacesListViewModel extends _$PlacesListViewModel {
  @override
  PlacesListState build() {
    Future.microtask(loadPlaces);
    return const PlacesListState();
  }

  Future<void> loadPlaces({String? tag}) async {
    state = state.copyWith(
      isLoading: true,
      selectedTag: tag,
      errorMessage: null,
    );

    try {
      final repository = ref.read(placesRepositoryProvider);
      final places = tag != null
          ? await repository.getPlacesByTag(tag)
          : await repository.getAllPlaces();

      state = state.copyWith(places: places, isLoading: false);
    } on Exception {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors du chargement des lieux',
      );
    }
  }

  Future<void> searchPlaces(String query) async {
    state = state.copyWith(searchQuery: query, isLoading: true);

    try {
      final repository = ref.read(placesRepositoryProvider);
      final places = await repository.searchPlaces(query);

      state = state.copyWith(places: places, isLoading: false);
    } on Exception {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Erreur lors de la recherche',
      );
    }
  }

  void clearSearch() {
    state = state.copyWith(searchQuery: '');
    loadPlaces(tag: state.selectedTag);
  }
}
