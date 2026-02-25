
import 'package:flutter/material.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geo_spots/core/utils/validator/validator.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_in/sign_in_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_view_model.g.dart';

@riverpod
class SignInViewModel extends _$SignInViewModel {
  // Validator
  final _requiredValidator = ValidatorRequired();
  final _emailValidator = ValidatorEmail();

  ValidatorRequired get requiredValidator => _requiredValidator;
  ValidatorEmail get emailValidator => _emailValidator;

  // Email and password form validators
  late final emailValidators = Validators(
    validators: [_requiredValidator, _emailValidator],
  );
  late final passwordValidators = Validators(validators: [_requiredValidator]);

  @override
  SignInState build() {
    return const SignInState();
  }

  Future<SignInState> updateState(SignInState state) async {
    this.state = state;
    return state;
  }

  void setupValidatorMessages(BuildContext context) {
    // Required validator
    _requiredValidator.withErrorMessage(
      'Champ requis',
    );

    // Email validator
    _emailValidator.withErrorMessage('Email invalide');
  }

  bool get isFormValid =>
      emailValidators.execute(state.email).isEmpty &&
      passwordValidators.execute(state.password).isEmpty;
}
