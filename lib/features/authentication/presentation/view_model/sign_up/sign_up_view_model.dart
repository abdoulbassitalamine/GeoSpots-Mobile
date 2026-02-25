import 'package:flutter/material.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geo_spots/core/utils/validator/validator.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_up/sign_up_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_view_model.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  // Individual Validators
  final _requiredValidator = ValidatorRequired();
  final _emailValidator = ValidatorEmail();
  final _minLengthValidator = ValidatorMinLength(minLength: 2);
  final _minPasswordLengthValidator = ValidatorMinLength(minLength: 12);
  final _uppercaseValidator = ValidatorUppercase();
  final _lowercaseValidator = ValidatorLowercase();
  final _digitValidator = ValidatorDigit();
  final _specialCharValidator = ValidatorSpecialChar();

  late final passwordMatchValidator = ValidatorPasswordMatch(
    getPasswordToMatch: () => state.password,
  );

  // Validator Groups
  late final firstNameValidators = Validators(
    validators: [_requiredValidator, _minLengthValidator],
  );

  late final lastNameValidators = Validators(
    validators: [_requiredValidator, _minLengthValidator],
  );

  late final emailValidators = Validators(
    validators: [_requiredValidator, _emailValidator],
  );

  late final passwordValidators = Validators(
    validators: [
      _requiredValidator,
      _minPasswordLengthValidator,
      _uppercaseValidator,
      _lowercaseValidator,
      _digitValidator,
      _specialCharValidator,
    ],
  );

  late final confirmPasswordValidators = Validators(
    validators: [_requiredValidator, passwordMatchValidator],
  );

  @override
  SignUpState build() {
    return const SignUpState();
  }

  Future<SignUpState> updateState(SignUpState state) async {
    this.state = state;
    return state;
  }

  void setupValidatorMessages(BuildContext context) {
    // Required validator
    _requiredValidator.withErrorMessage('Champ requis');

    // Email validator
    _emailValidator.withErrorMessage('Email invalide');

    // Min length validators
    _minLengthValidator.withErrorMessage(
      'Ce champ doit contenir au moins 2 caractères',
    );

    // Min password length validator
    _minPasswordLengthValidator.withErrorMessage(
      'Ce champ doit contenir au moins 12 caractères',
    );

    // Password validators
    _uppercaseValidator.withErrorMessage(
      'Le mot de passe doit contenir au moins une majuscule',
    );

    _lowercaseValidator.withErrorMessage(
      'Le mot de passe doit contenir au moins une minuscule',
    );

    _digitValidator.withErrorMessage(
      'Le mot de passe doit contenir au moins un chiffre',
    );

    _specialCharValidator.withErrorMessage(
      'Le mot de passe doit contenir au moins un caractère spécial',
    );

    passwordMatchValidator.withErrorMessage(
      'Les mots de passe ne correspondent pas',
    );
  }

  bool get isCoordinatesFormValid =>
      firstNameValidators.execute(state.firstName).isEmpty &&
      lastNameValidators.execute(state.lastName).isEmpty &&
      emailValidators.execute(state.email).isEmpty &&
      _coordinatesFieldsNotEmpty;

  bool get _coordinatesFieldsNotEmpty =>
      state.firstName.isNotEmpty &&
      state.lastName.isNotEmpty &&
      state.email.isNotEmpty;

  bool get isPasswordFormValid =>
      passwordValidators.execute(state.password).isEmpty &&
      confirmPasswordValidators.execute(state.confirmPassword).isEmpty &&
      _passwordFieldsNotEmpty;

  bool get _passwordFieldsNotEmpty =>
      state.password.isNotEmpty && state.confirmPassword.isNotEmpty;

  bool get isFormValid => isCoordinatesFormValid && isPasswordFormValid;

  bool isFirstNameValid(String value) =>
      firstNameValidators.execute(value).isEmpty;

  bool isLastNameValid(String value) =>
      lastNameValidators.execute(value).isEmpty;

  bool isEmailValid(String value) => emailValidators.execute(value).isEmpty;

  bool isPasswordValid(String value) =>
      passwordValidators.execute(value).isEmpty;

  bool isConfirmPasswordValid(String value) =>
      confirmPasswordValidators.execute(value).isEmpty;
}
