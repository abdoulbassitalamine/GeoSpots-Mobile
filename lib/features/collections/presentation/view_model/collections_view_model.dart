import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
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
    final collections = _generateCollectionsFromTags(allPlaces);

    state = state.copyWith(
      collections: collections,
      allPlaces: allPlaces,
      totalPlaces: allPlaces.length,
      isLoading: false,
    );
  }

  List<CollectionEntity> _generateCollectionsFromTags(
    List<PlaceEntity> places,
  ) {
    // Extraire tous les tags uniques
    final Set<String> allTags = {};
    for (var place in places) {
      allTags.addAll(place.tags);
    }

    // Créer une collection pour chaque tag
    final List<CollectionEntity> collections = [
      // Collection "Tous les lieux"
      CollectionEntity.all(places),
    ];

    // Ajouter les collections par tag
    for (var tag in allTags) {
      final placesWithTag = places
          .where((place) => place.tags.contains(tag))
          .toList();

      collections.add(
        CollectionEntity(
          tag: tag,
          placesCount: placesWithTag.length,
          places: placesWithTag,
        ),
      );
    }

    // Trier par nombre de lieux décroissant
    collections.sort((a, b) {
      if (a.tag == 'all') return -1;
      if (b.tag == 'all') return 1;
      return b.placesCount.compareTo(a.placesCount);
    });

    return collections;
  }

  Future<void> refresh() async {
    await _loadDummyData();
  }

  Future<void> importCollection() async {
    // TODO: Implémenter l'import de collection (GPX, KML, GeoJSON)
    // Cela ajoutera des lieux avec leurs tags
  }
}
