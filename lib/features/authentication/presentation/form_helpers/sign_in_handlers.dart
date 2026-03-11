import 'package:flutter/material.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geo_spots/features/authentication/data/exception/auth_exception.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_in_controllers.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/authentication_view_model.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_in/sign_in_view_model.dart';
import 'package:geo_spots/shared/design_system/widgets/snackbar/snackbar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInHandlers {
  static void onEmailChanged(
    String value,
    WidgetRef ref,
    SignInViewModel notifier,
  ) {
    notifier.updateState(
      ref.read(signInViewModelProvider).copyWith(email: value),
    );
  }

  static void onPasswordChanged(
    String value,
    WidgetRef ref,
    SignInViewModel notifier,
  ) {
    notifier.updateState(
      ref.read(signInViewModelProvider).copyWith(password: value),
    );
  }

  static Future<void> onSubmit(
    WidgetRef ref,
    BuildContext context,
    SignInControllers controllers,
  ) async {
    if (controllers.isLoading.value) {
      return;
    }
    controllers.isLoading.value = true;
    FocusScope.of(context).unfocus();
    controllers.resetErrors();

    final signInState = ref.read(signInViewModelProvider);
    final signInNotifier = ref.read(signInViewModelProvider.notifier);
    final emailValidation = signInNotifier.emailValidators
        .executeWithPriorityMessage(signInState.email)
        .message;
    final passwordValidation = signInNotifier.passwordValidators
        .executeWithPriorityMessage(signInState.password)
        .message;

    if (emailValidation != null || passwordValidation != null) {
      controllers.emailError.value = emailValidation;
      controllers.passwordError.value = passwordValidation;
      controllers.isLoading.value = false;
      return;
    }

    try {
      await ref
          .read(authenticationViewModelProvider.notifier)
          .signIn(mail: signInState.email, password: signInState.password);

      if (!context.mounted) {
        return;
      }
    } on WrongEmailOrPasswordException {
      if (!context.mounted) {
        return;
      }
      controllers.passwordError.value =
          'Combinaison incorrecte, veuillez réessayer';
      controllers.emailError.value = ' ';
    } on Exception catch (error) {
      if (!context.mounted) {
        return;
      }
      GsLogger().e(error);
      GSTopSnackbar.showError(
        context,
        message: 'Une erreur est survenue, veuillez réessayer plus tard',
      );
    } finally {
      controllers.isLoading.value = false;
    }
  }
}
