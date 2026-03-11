import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/shared/design_system/widgets/snackbar/snackbar.dart';
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
    GSSnackbarMessage? snackbarMessage,
  }) = _PlacesListState;
}
