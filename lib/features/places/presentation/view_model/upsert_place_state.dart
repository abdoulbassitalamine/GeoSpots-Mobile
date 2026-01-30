import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/core/constants/app_constants.dart';
import 'package:latlong2/latlong.dart';

part 'upsert_place_state.freezed.dart';

@freezed
sealed class UpsertPlaceState with _$UpsertPlaceState {
  const factory UpsertPlaceState({
    String? placeId,
    @Default('') String title,
    @Default('') String description,
    @Default([]) List<String> tags,
    String? imageUrl,
    LatLng? position,
    @Default('') String address,
    @Default(0) int currentStep,
    @Default(false) bool isLoading,
    @Default(false) bool isSaving,
    String? errorMessage,
  }) = _UpsertPlaceState;

  const UpsertPlaceState._();

  bool get isEditMode => placeId != null && placeId != kPlaceCreationId;
  bool get isCreateMode => !isEditMode;
}
