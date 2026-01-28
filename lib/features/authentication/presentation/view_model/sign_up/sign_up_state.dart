import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_up_state.freezed.dart';

@freezed
sealed class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default('') String firstName,
    @Default('') String lastName,
    @Default('') String email,
    @Default('') String password,
    @Default('') String confirmPassword,
    @Default(false) bool isLoading,
    @Default(false) bool isPasswordVisible,
    @Default(false) bool isConfirmPasswordVisible,
  }) = _SignUpState;
}