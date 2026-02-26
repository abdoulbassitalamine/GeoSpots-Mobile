import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'place_entity.dart';

extension PlaceListExtension on List<PlaceEntity> {
  List<CollectionEntity> generateCollectionsFromTags() {
    final allTags = <String>{};
    for (final place in this) {
      allTags.addAll(place.tags);
    }

    final collections = <CollectionEntity>[];

    for (final tag in allTags) {
      final placesWithTag = where((place) => place.tags.contains(tag)).toList();

      collections.add(
        CollectionEntity(
          id: 'tag:$tag',
          tag: tag,
          placesCount: placesWithTag.length,
        ),
      );
    }

    collections.sort((a, b) => b.placesCount.compareTo(a.placesCount));

    return collections;
  }

  List<PlaceEntity> filterByTag(String tag) {
    return where((place) => place.tags.contains(tag)).toList();
  }

  List<PlaceEntity> filterByQuery(String query) {
    if (query.isEmpty) return this;
    return where((place) => place.matchesSearch(query)).toList();
  }

  Map<String, List<PlaceEntity>> groupByCity() {
    final grouped = <String, List<PlaceEntity>>{};
    for (final place in this) {
      final city = place.city ?? 'Sans ville';
      grouped.putIfAbsent(city, () => []).add(place);
    }
    return grouped;
  }

  Map<String, List<PlaceEntity>> groupByCountry() {
    final grouped = <String, List<PlaceEntity>>{};
    for (final place in this) {
      final country = place.country ?? 'Sans pays';
      grouped.putIfAbsent(country, () => []).add(place);
    }
    return grouped;
  }

  Set<String> getAllTags() {
    final allTags = <String>{};
    for (final place in this) {
      allTags.addAll(place.tags);
    }
    return allTags;
  }

  List<PlaceEntity> sortByDateDesc() {
    final sorted = List<PlaceEntity>.from(this);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }

  List<PlaceEntity> getRecent({int limit = 5}) {
    return sortByDateDesc().take(limit).toList();
  }
}
