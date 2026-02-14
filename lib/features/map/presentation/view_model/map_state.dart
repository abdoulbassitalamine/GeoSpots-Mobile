import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';

part 'map_state.freezed.dart';

@freezed
sealed class MapState with _$MapState {
  const factory MapState({
    @Default([]) List<PlaceEntity> allPlaces,
    @Default([]) List<PlaceEntity> visiblePlaces,
    @Default([]) List<String> categories,
    @Default('Tous') String selectedCategory,
    @Default('') String searchQuery,
    String? selectedPlaceId,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _MapState;
}
