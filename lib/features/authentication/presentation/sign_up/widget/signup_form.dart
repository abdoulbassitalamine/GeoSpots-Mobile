import 'package:flutter/material.dart';
import 'package:geo_spots/core/utils/extensions/sized_box_extension.dart';
import 'package:geo_spots/core/utils/extensions/value_notifier_ext.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_up_controllers.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_up_handlers.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_up_validators.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_up/sign_up_view_model.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupForm extends HookConsumerWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(signUpViewModelProvider.notifier);
    final state = ref.watch(signUpViewModelProvider);
    final identityControllers = SignUpIdentityControllers.initialize(state);
    final passwordControllers = SignUpPasswordControllers.initialize(state);

    SignUpValidators.setupValidatorMessages(context, notifier);
    SignUpValidators.setupIdentityInitialValidation(
      ref,
      notifier,
      identityControllers,
    );
    SignUpValidators.setupIdentityFocusListeners(identityControllers, notifier);
    SignUpValidators.setupPasswordInitialValidation(
      ref,
      notifier,
      passwordControllers,
    );
    SignUpValidators.setupPasswordFocusListeners(passwordControllers, notifier);

    return Column(
      spacing: GSSpacing.$200,
      children: [
        GSInlineTextField(
          label: 'Prénom',
          controller: identityControllers.firstNameController,
          focusNode: identityControllers.firstNameFocusNode,
          error: identityControllers.firstNameError.notEmptyOrNull(),
          onChanged: (value) {
            SignUpValidators.validateFirstName(
              identityControllers.firstNameController,
              notifier,
              identityControllers.firstNameError,
            );
            SignUpHandlers.onFirstNameChanged(value, ref, notifier);
          },
          onSubmitted: (_) => identityControllers.lastNameFocusNode.requestFocus(),
        ),
        GSInlineTextField(
          label: 'Nom',
          controller: identityControllers.lastNameController,
          focusNode: identityControllers.lastNameFocusNode,
          error: identityControllers.lastNameError.notEmptyOrNull(),
          onChanged: (value) {
            SignUpValidators.validateLastName(
              identityControllers.lastNameController,
              notifier,
              identityControllers.lastNameError,
            );
            SignUpHandlers.onLastNameChanged(value, ref, notifier);
          },
          onSubmitted: (_) => identityControllers.emailFocusNode.requestFocus(),
        ),
        GSInlineTextField(
          label: 'Email',
          controller: identityControllers.emailController,
          focusNode: identityControllers.emailFocusNode,
          type: TextInputType.emailAddress,
          error: identityControllers.emailError.notEmptyOrNull(),
          onChanged: (value) {
            SignUpValidators.validateEmail(
              identityControllers.emailController,
              notifier,
              identityControllers.emailError,
            );
            SignUpHandlers.onEmailChanged(value, ref, notifier);
          },
          onSubmitted: (_) => passwordControllers.passwordFocusNode.requestFocus(),
        ),
        GSSpacing.$50.toInt().toHeight,
        GSInlinePasswordField(
          label: 'Mot de passe',
          controller: passwordControllers.passwordController,
          focusNode: passwordControllers.passwordFocusNode,
          error: passwordControllers.passwordError.notEmptyOrNull(),
          obscureText: !passwordControllers.isPasswordVisible.value,
          onVisibilityChanged: (value) =>
              passwordControllers.isPasswordVisible.value = !value,
          onChanged: (value) {
            SignUpValidators.validatePassword(
              passwordControllers.passwordController,
              notifier,
              passwordControllers.passwordError,
            );
            SignUpHandlers.onPasswordChanged(value, ref, notifier);
          },
          onSubmitted: (_) =>
              passwordControllers.confirmPasswordFocusNode.requestFocus(),
        ),
        GSInlinePasswordField(
          label: 'Confirmer le mot de passe',
          controller: passwordControllers.confirmPasswordController,
          focusNode: passwordControllers.confirmPasswordFocusNode,
          error: passwordControllers.confirmPasswordError.notEmptyOrNull(),
          obscureText: !passwordControllers.isConfirmPasswordVisible.value,
          onVisibilityChanged: (value) =>
              passwordControllers.isConfirmPasswordVisible.value = !value,
          onChanged: (value) {
            SignUpValidators.validateConfirmPassword(
              passwordControllers.confirmPasswordController,
              notifier,
              passwordControllers.confirmPasswordError,
            );
            SignUpHandlers.onConfirmPasswordChanged(value, ref, notifier);
          },
          onSubmitted: (_) {
            if (notifier.isFormValid) {
              SignUpHandlers.onSubmit(ref, context, passwordControllers);
            }
          },
        ),
        GSSpacing.$100.toInt().toHeight,
        GSContainerButton.filled(
          padding: const EdgeInsets.symmetric(vertical: GSSpacing.$250),
          isLoading: passwordControllers.isLoading.value,
          enabled: notifier.isFormValid,
          onPressed: () => SignUpHandlers.onSubmit(ref, context, passwordControllers),
          text: 'S’inscrire',
          gradient: GSColorTokens.primaryGradientHorizontal,
          radius: GSRadius.l,
        ),
      ],
    );
  }
}
