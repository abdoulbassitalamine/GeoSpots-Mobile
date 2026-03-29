import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_shared_access_state.freezed.dart';

@freezed
sealed class AddSharedAccessState with _$AddSharedAccessState {
  const factory AddSharedAccessState({
    @Default('') String url,
    @Default('') String token,
  }) = _AddSharedAccessState;
}
