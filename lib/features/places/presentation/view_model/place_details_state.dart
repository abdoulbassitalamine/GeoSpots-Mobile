import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/shared/design_system/widgets/snackbar/snackbar.dart';
import '../../domain/entity/place_entity.dart';

part 'place_details_state.freezed.dart';

@freezed
sealed class PlaceDetailsState with _$PlaceDetailsState {
  const factory PlaceDetailsState({
    PlaceEntity? place,
    @Default(false) bool isLoading,
    @Default(false) bool shouldRefreshParent,
    String? loadErrorMessage,
    GSSnackbarMessage? snackbarMessage,
  }) = _PlaceDetailsState;
}
