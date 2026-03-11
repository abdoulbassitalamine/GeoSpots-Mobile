import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geo_spots/shared/design_system/widgets/snackbar/snackbar.dart';

import '../../../authentication/domain/entity/user/user_entity.dart';
import '../../../tracking/domain/entity/location_share_session_entity.dart';

part 'profile_state.freezed.dart';

@freezed
sealed class ProfileState with _$ProfileState {
  const factory ProfileState({
    UserEntity? user,
    @Default(0) int totalPlaces,
    @Default(0) int totalCollections,
    @Default(0) int sharedPlaces,
    @Default(false) bool isLoading,
    @Default(false) bool isTrackingEnabled,
    @Default(false) bool isSharing,
    @Default(false) bool isSharingLoading,
    LocationShareSessionEntity? activeShareSession,
    String? errorMessage,
    GSSnackbarMessage? snackbarMessage,
  }) = _ProfileState;
}
