import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:geo_spots/features/places/domain/entity/place_list_extension.dart';
import 'package:geo_spots/features/places/domain/repository/places_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entity/collection_entity.dart';
import 'collections_state.dart';

part 'collections_view_model.g.dart';

@riverpod
class CollectionsViewModel extends _$CollectionsViewModel {
  @override
  CollectionsState build() {
    Future.microtask(_loadDummyData);
    return const CollectionsState();
  }

  Future<void> _loadDummyData() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    final allPlaces = await ref.watch(placesRepositoryProvider).getAllPlaces();
    final collections = allPlaces.generateCollectionsFromTags();

    state = state.copyWith(
      collections: collections,
      allPlaces: allPlaces,
      totalPlaces: allPlaces.length,
      isLoading: false,
    );
  }



  Future<void> refresh() async {
    await _loadDummyData();
  }

  Future<void> importCollection() async {
    // TODO: Implémenter l'import de collection (GPX, KML, GeoJSON)
    // Cela ajoutera des lieux avec leurs tags
  }
}
