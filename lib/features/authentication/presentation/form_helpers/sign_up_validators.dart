import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_up_controllers.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_up/sign_up_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpValidators {
  static void setupValidatorMessages(
    BuildContext context,
    SignUpViewModel notifier,
  ) {
    notifier.setupValidatorMessages(context);
  }

  static void setupIdentityInitialValidation(
    WidgetRef ref,
    SignUpViewModel notifier,
    SignUpIdentityControllers controllers,
  ) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controllers.firstNameController.text.isNotEmpty) {
          controllers.firstNameError.value = notifier.firstNameValidators
              .executeWithPriorityMessage(controllers.firstNameController.text)
              .message;
        }

        if (controllers.lastNameController.text.isNotEmpty) {
          controllers.lastNameError.value = notifier.lastNameValidators
              .executeWithPriorityMessage(controllers.lastNameController.text)
              .message;
        }

        if (controllers.emailController.text.isNotEmpty) {
          controllers.emailError.value = notifier.emailValidators
              .executeWithPriorityMessage(controllers.emailController.text)
              .message;
        }

        notifier.updateState(
          ref
              .read(signUpViewModelProvider)
              .copyWith(
                firstName: controllers.firstNameController.text,
                lastName: controllers.lastNameController.text,
                email: controllers.emailController.text,
              ),
        );
      });
      return null;
    }, const []);
  }

  static void setupIdentityFocusListeners(
    SignUpIdentityControllers controllers,
    SignUpViewModel notifier,
  ) {
    useEffect(() {
      void handleFirstNameFocusChange() {
        if (controllers.firstNameFocusNode.hasFocus) {
          controllers.firstNameError.value = null;
        } else {
          validateFirstName(
            controllers.firstNameController,
            notifier,
            controllers.firstNameError,
          );
        }
      }

      void handleLastNameFocusChange() {
        if (controllers.lastNameFocusNode.hasFocus) {
          controllers.lastNameError.value = null;
        } else {
          validateLastName(
            controllers.lastNameController,
            notifier,
            controllers.lastNameError,
          );
        }
      }

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

      controllers.firstNameFocusNode.addListener(handleFirstNameFocusChange);
      controllers.lastNameFocusNode.addListener(handleLastNameFocusChange);
      controllers.emailFocusNode.addListener(handleEmailFocusChange);

      return () {
        controllers.firstNameFocusNode.removeListener(
          handleFirstNameFocusChange,
        );
        controllers.lastNameFocusNode.removeListener(handleLastNameFocusChange);
        controllers.emailFocusNode.removeListener(handleEmailFocusChange);
      };
    }, const []);
  }

  static void setupPasswordInitialValidation(
    WidgetRef ref,
    SignUpViewModel notifier,
    SignUpPasswordControllers controllers,
  ) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controllers.passwordController.text.isNotEmpty) {
          controllers.passwordError.value = notifier.passwordValidators
              .executeWithPriorityMessage(controllers.passwordController.text)
              .message;
        }
        if (controllers.confirmPasswordController.text.isNotEmpty) {
          controllers.confirmPasswordError.value = notifier
              .confirmPasswordValidators
              .executeWithPriorityMessage(
                controllers.confirmPasswordController.text,
              )
              .message;
        }

        notifier.updateState(
          ref
              .read(signUpViewModelProvider)
              .copyWith(
                password: controllers.passwordController.text,
                confirmPassword: controllers.confirmPasswordController.text,
              ),
        );
      });
      return null;
    }, const []);
  }

  static void setupPasswordFocusListeners(
    SignUpPasswordControllers controllers,
    SignUpViewModel notifier,
  ) {
    useEffect(() {
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

      void handleConfirmPasswordFocusChange() {
        if (controllers.confirmPasswordFocusNode.hasFocus) {
          controllers.confirmPasswordError.value = null;
        } else {
          validateConfirmPassword(
            controllers.confirmPasswordController,
            notifier,
            controllers.confirmPasswordError,
          );
        }
      }

      controllers.passwordFocusNode.addListener(handlePasswordFocusChange);
      controllers.confirmPasswordFocusNode.addListener(
        handleConfirmPasswordFocusChange,
      );

      return () {
        controllers.passwordFocusNode.removeListener(handlePasswordFocusChange);
        controllers.confirmPasswordFocusNode.removeListener(
          handleConfirmPasswordFocusChange,
        );
      };
    }, const []);
  }

  static void validateFirstName(
    TextEditingController controller,
    SignUpViewModel notifier,
    ValueNotifier<String?> error,
  ) {
    if (controller.text.isEmpty) {
      error.value = null;
      return;
    }

    error.value = notifier.firstNameValidators
        .executeWithPriorityMessage(controller.text)
        .message;
  }

  static void validateLastName(
    TextEditingController controller,
    SignUpViewModel notifier,
    ValueNotifier<String?> error,
  ) {
    if (controller.text.isEmpty) {
      error.value = null;
      return;
    }

    error.value = notifier.lastNameValidators
        .executeWithPriorityMessage(controller.text)
        .message;
  }

  static void validateEmail(
    TextEditingController controller,
    SignUpViewModel notifier,
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
    SignUpViewModel notifier,
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

  static void validateConfirmPassword(
    TextEditingController controller,
    SignUpViewModel notifier,
    ValueNotifier<String?> error,
  ) {
    if (controller.text.isEmpty) {
      error.value = null;
      return;
    }

    error.value = notifier.confirmPasswordValidators
        .executeWithPriorityMessage(controller.text)
        .message;
  }
}
