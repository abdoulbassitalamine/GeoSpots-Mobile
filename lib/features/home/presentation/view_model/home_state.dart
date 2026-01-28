import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/place_entity.dart';

part 'home_state.freezed.dart';

@freezed
sealed class HomeState with _$HomeState {
  const factory HomeState({
    @Default('') String username,
    @Default(0) int totalLocations,
    @Default(0) int totalCollections,
    @Default([]) List<PlaceEntity> recentPlaces,
    @Default(false) bool isLoading,
  }) = _HomeState;
}