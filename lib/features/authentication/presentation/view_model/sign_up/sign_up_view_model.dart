
import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_up/sign_up_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/utils/extensions/validators_ext.dart';
import '../../../../../core/utils/validator/validator.dart';

part 'sign_up_view_model.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  // Individual Validators
  final _requiredValidator = ValidatorRequired();
  final _emailValidator = ValidatorEmail();
  final _minLengthValidator = ValidatorMinLength(minLength: 2);
  final _minPasswordLengthValidator = ValidatorMinLength(minLength: 8);

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

  late final genderValidators = Validators(validators: [_requiredValidator]);



  late final passwordValidators = Validators(
    validators: [
      _requiredValidator,
      _uppercaseValidator,
      _lowercaseValidator,
      _digitValidator,
      _specialCharValidator,
      _minPasswordLengthValidator,
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
    _requiredValidator.withErrorMessage(
      'Ce champ est obligatoire',
    );

    // Email validator
    _emailValidator.withErrorMessage('Adresse email invalide');

    // Min length validators
    _minLengthValidator.withErrorMessage('Minimum 2 caractères');

    // Min length validators
    _minPasswordLengthValidator.withErrorMessage(
      'Minimum 8 caractères',
    );


    // Password validators
    _uppercaseValidator.withErrorMessage(
      'Au moins une majuscule',
    );

    // Password validators
    _lowercaseValidator.withErrorMessage(
      'Au moins une minuscule',
    );
    // Password validators
    _digitValidator.withErrorMessage('Au moins un chiffre');
    // Password validators
    _specialCharValidator.withErrorMessage(
      'Au moins un caractère spécial',
    );

    passwordMatchValidator.withErrorMessage(
      'Les mots de passe ne correspondent pas',
    );
  }

  bool get isFormValid =>
      firstNameValidators.execute(state.firstName).isEmpty &&
      lastNameValidators.execute(state.lastName).isEmpty &&
      emailValidators.execute(state.email).isEmpty &&
      passwordValidators.execute(state.password).isEmpty &&
      confirmPasswordValidators.execute(state.confirmPassword).isEmpty &&
      _allFieldsNotEmpty;

  bool get _allFieldsNotEmpty =>
      state.firstName.isNotEmpty &&
      state.lastName.isNotEmpty &&
      state.email.isNotEmpty &&
      state.password.isNotEmpty &&
      state.confirmPassword.isNotEmpty;

  // Convenience methods for checking individual field validity
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
