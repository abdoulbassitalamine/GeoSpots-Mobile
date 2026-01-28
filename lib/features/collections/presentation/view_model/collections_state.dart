import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import '../../domain/entity/collection_entity.dart';

part 'collections_state.freezed.dart';

@freezed
sealed class CollectionsState with _$CollectionsState {
  const factory CollectionsState({
    @Default([]) List<CollectionEntity> collections,
    @Default([]) List<PlaceEntity> allPlaces,
    @Default(0) int totalPlaces,
    @Default(false) bool isLoading,
    String? error,
  }) = _CollectionsState;
}