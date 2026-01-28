
import 'package:geo_spots/features/authentication/presentation/view_model/sign_in/sign_in_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../core/utils/validator/validator.dart';

part 'sign_in_view_model.g.dart';

@riverpod
class SignInViewModel extends _$SignInViewModel {
  // Validator
  final requiredValidator = ValidatorRequired();
  final emailValidator = ValidatorEmail();

  // Email and password form validators
  late final emailValidators = Validators(
    validators: [requiredValidator, emailValidator],
  );
  late final passwordValidators = Validators(validators: [requiredValidator]);

  @override
  SignInState build() {
    return const SignInState();
  }

  Future<SignInState> updateState(SignInState state) async {
    this.state = state;
    return state;
  }

  bool get isFormValid =>
      emailValidators.execute(state.email).isEmpty &&
      passwordValidators.execute(state.password).isEmpty;
}
