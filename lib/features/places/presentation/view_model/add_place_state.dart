import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'add_place_state.freezed.dart';

@freezed
sealed class AddPlaceState with _$AddPlaceState {
  const factory AddPlaceState({
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
  }) = _AddPlaceState;
}