import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_state.freezed.dart';

@freezed
sealed class SignInState with _$SignInState {
  const factory SignInState({
    @Default('') String password,
    @Default('') String email,
  }) = _SignInState;
}
