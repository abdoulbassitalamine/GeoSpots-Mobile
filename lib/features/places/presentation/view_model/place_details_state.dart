import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entity/place_entity.dart';

part 'place_details_state.freezed.dart';

@freezed
sealed class PlaceDetailsState with _$PlaceDetailsState {
  const factory PlaceDetailsState({
    PlaceEntity? place,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _PlaceDetailsState;
}
