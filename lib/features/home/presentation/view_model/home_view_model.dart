import 'package:geo_spots/features/places/domain/entity/place_list_extension.dart';
import 'package:geo_spots/features/places/domain/repository/places_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'home_state.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  HomeState build() {
    Future.microtask(_loadDummyData);
    return const HomeState();
  }

  Future<void> _loadDummyData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));

    final recentPlaces = await ref
        .watch(placesRepositoryProvider)
        .getRecentPlaces();
    final allPlaces = await ref.watch(placesRepositoryProvider).getAllPlaces();
    final collections = allPlaces.generateCollectionsFromTags();

    state = state.copyWith(
      username: 'Abdoul Bassit',
      totalLocations: allPlaces.length,
      totalCollections: collections.length,
      recentPlaces: recentPlaces,
      isLoading: false,
    );
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadDummyData();
  }
}
