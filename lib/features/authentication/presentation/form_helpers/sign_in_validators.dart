import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_in_controllers.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_in/sign_in_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignInValidators {
  static void setupValidatorMessages(
    BuildContext context,
    SignInViewModel notifier,
  ) {
    notifier.setupValidatorMessages(context);
  }

  static void setupInitialValidation(
    WidgetRef ref,
    SignInViewModel notifier,
    SignInControllers controllers,
  ) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controllers.emailController.text.isNotEmpty) {
          controllers.emailError.value = notifier.emailValidators
              .executeWithPriorityMessage(controllers.emailController.text)
              .message;
        }

        if (controllers.passwordController.text.isNotEmpty) {
          controllers.passwordError.value = notifier.passwordValidators
              .executeWithPriorityMessage(controllers.passwordController.text)
              .message;
        }

        notifier.updateState(
          ref
              .read(signInViewModelProvider)
              .copyWith(
                email: controllers.emailController.text,
                password: controllers.passwordController.text,
              ),
        );
      });

      return null;
    }, const []);
  }

  static void setupAllFocusListeners(
    SignInControllers controllers,
    SignInViewModel notifier,
  ) {
    useEffect(() {
      void handleEmailFocusChange() {
        if (controllers.emailFocusNode.hasFocus) {
          controllers.emailError.value = null;
        } else {
          validateEmail(
            controllers.emailController,
            notifier,
            controllers.emailError,
          );
        }
      }

      void handlePasswordFocusChange() {
        if (controllers.passwordFocusNode.hasFocus) {
          controllers.passwordError.value = null;
        } else {
          validatePassword(
            controllers.passwordController,
            notifier,
            controllers.passwordError,
          );
        }
      }

      controllers.emailFocusNode.addListener(handleEmailFocusChange);
      controllers.passwordFocusNode.addListener(handlePasswordFocusChange);

      return () {
        controllers.emailFocusNode.removeListener(handleEmailFocusChange);
        controllers.passwordFocusNode.removeListener(handlePasswordFocusChange);
      };
    }, const []);
  }

  static void validateEmail(
    TextEditingController controller,
    SignInViewModel notifier,
    ValueNotifier<String?> error,
  ) {
    if (controller.text.isEmpty) {
      error.value = null;
      return;
    }

    error.value = notifier.emailValidators
        .executeWithPriorityMessage(controller.text)
        .message;
  }

  static void validatePassword(
    TextEditingController controller,
    SignInViewModel notifier,
    ValueNotifier<String?> error,
  ) {
    if (controller.text.isEmpty) {
      error.value = null;
      return;
    }

    error.value = notifier.passwordValidators
        .executeWithPriorityMessage(controller.text)
        .message;
  }
}
