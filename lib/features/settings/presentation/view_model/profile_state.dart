import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../authentication/domain/entity/user/user_entity.dart';

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
    String? errorMessage,
  }) = _ProfileState;
}
