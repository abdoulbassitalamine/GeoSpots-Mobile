import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/place_entity.dart';

part 'places_list_state.freezed.dart';

@freezed
sealed class PlacesListState with _$PlacesListState {
  const factory PlacesListState({
    @Default([]) List<PlaceEntity> places,
    @Default(false) bool isLoading,
    @Default('') String searchQuery,
    String? selectedTag,
    String? errorMessage,
  }) = _PlacesListState;
}