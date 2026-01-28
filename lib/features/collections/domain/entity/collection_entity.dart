import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';

part 'collection_entity.freezed.dart';

@Freezed(fromJson: false)
sealed class CollectionEntity with _$CollectionEntity {
  const factory CollectionEntity({
    required String tag,
    required int placesCount,
    required List<PlaceEntity> places,
  }) = _CollectionEntity;

  const CollectionEntity._();

  static CollectionEntity all(List<PlaceEntity> allPlaces) {
    return CollectionEntity(
      tag: 'all',
      placesCount: allPlaces.length,
      places: allPlaces,
    );
  }
}