import 'package:flutter/material.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_up_controllers.dart';
import 'package:geo_spots/features/authentication/presentation/route/route_data.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/authentication_view_model.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_up/sign_up_view_model.dart';
import 'package:geo_spots/shared/design_system/widgets/snackbar/snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpHandlers {
  static void onFirstNameChanged(
    String value,
    WidgetRef ref,
    SignUpViewModel notifier,
  ) {
    notifier.updateState(
      ref.read(signUpViewModelProvider).copyWith(firstName: value),
    );
  }

  static void onLastNameChanged(
    String value,
    WidgetRef ref,
    SignUpViewModel notifier,
  ) {
    notifier.updateState(
      ref.read(signUpViewModelProvider).copyWith(lastName: value),
    );
  }

  static void onEmailChanged(
    String value,
    WidgetRef ref,
    SignUpViewModel notifier,
  ) {
    notifier.updateState(
      ref.read(signUpViewModelProvider).copyWith(email: value),
    );
  }

  static void onPasswordChanged(
    String value,
    WidgetRef ref,
    SignUpViewModel notifier,
  ) {
    notifier.updateState(
      ref.read(signUpViewModelProvider).copyWith(password: value),
    );
  }

  static void onConfirmPasswordChanged(
    String value,
    WidgetRef ref,
    SignUpViewModel notifier,
  ) {
    notifier.updateState(
      ref.read(signUpViewModelProvider).copyWith(confirmPassword: value),
    );
  }

  static Future<void> onSubmit(
    WidgetRef ref,
    BuildContext context,
    SignUpPasswordControllers controllers,
  ) async {
    if (controllers.isLoading.value) {
      return;
    }
    controllers.isLoading.value = true;
    FocusScope.of(context).unfocus();
    controllers.resetErrors();

    final state = ref.read(signUpViewModelProvider);
    final notifier = ref.read(signUpViewModelProvider.notifier);
    final passwordValidation = notifier.passwordValidators
        .executeWithPriorityMessage(state.password)
        .message;
    final confirmPasswordValidation = notifier.confirmPasswordValidators
        .executeWithPriorityMessage(state.confirmPassword)
        .message;

    if (passwordValidation != null || confirmPasswordValidation != null) {
      controllers.passwordError.value = passwordValidation;
      controllers.confirmPasswordError.value = confirmPasswordValidation;
      controllers.isLoading.value = false;
      return;
    }

    try {
      await ref
          .read(authenticationViewModelProvider.notifier)
          .signUp(
            firstName: state.firstName,
            lastName: state.lastName,
            mail: state.email,
            password: state.password,
            passwordConfirmation: state.confirmPassword,
          );

      if (!context.mounted) {
        return;
      }
      SignInRouteData().go(context);
    } on Exception catch (error) {
      if (!context.mounted) {
        return;
      }
      GsLogger().e(error);
      GSTopSnackbar.showError(
        context,
        message: 'Une erreur est survenue, veuillez réessayer',
      );
    } finally {
      controllers.isLoading.value = false;
    }
  }
}
