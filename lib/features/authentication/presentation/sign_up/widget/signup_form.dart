import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/utils/extensions/sized_box_extension.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
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
    final currentStep = useState(0);

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

    bool validateIdentityStep() {
      identityControllers.firstNameError.value = notifier.firstNameValidators
          .executeWithPriorityMessage(
            identityControllers.firstNameController.text.trim(),
          )
          .message;
      identityControllers.lastNameError.value = notifier.lastNameValidators
          .executeWithPriorityMessage(
            identityControllers.lastNameController.text.trim(),
          )
          .message;
      identityControllers.emailError.value = notifier.emailValidators
          .executeWithPriorityMessage(
            identityControllers.emailController.text.trim(),
          )
          .message;

      return identityControllers.firstNameError.value == null &&
          identityControllers.lastNameError.value == null &&
          identityControllers.emailError.value == null;
    }

    void goToPasswordStep() {
      FocusScope.of(context).unfocus();
      if (!validateIdentityStep()) {
        return;
      }
      currentStep.value = 1;
      passwordControllers.passwordFocusNode.requestFocus();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: GSSpacing.$250,
      children: [
        _SignUpProgressHeader(currentStep: currentStep.value),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: currentStep.value == 0
              ? _IdentityStep(
                  key: const ValueKey('identity-step'),
                  ref: ref,
                  notifier: notifier,
                  identityControllers: identityControllers,
                  onContinue: goToPasswordStep,
                )
              : _PasswordStep(
                  key: const ValueKey('password-step'),
                  ref: ref,
                  notifier: notifier,
                  passwordControllers: passwordControllers,
                  onBack: () {
                    FocusScope.of(context).unfocus();
                    currentStep.value = 0;
                  },
                  onSubmit: () =>
                      SignUpHandlers.onSubmit(ref, context, passwordControllers),
                ),
        ),
      ],
    );
  }
}

class _IdentityStep extends StatelessWidget {
  const _IdentityStep({
    super.key,
    required this.ref,
    required this.notifier,
    required this.identityControllers,
    required this.onContinue,
  });

  final WidgetRef ref;
  final SignUpViewModel notifier;
  final SignUpIdentityControllers identityControllers;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: GSSpacing.$200,
      children: [
        _StepIntro(
          title: 'Informations personnelles',
          description: 'Commencez par votre nom, prénom et adresse email.',
        ),
        GSTextField(
          maxLines: 1,
          label: 'Prénom',
          controller: identityControllers.firstNameController,
          focusNode: identityControllers.firstNameFocusNode,
          keyboardActions: TextInputAction.next,
          error: identityControllers.firstNameError.notEmptyOrNull(),
          onValueChange: (value) {
            SignUpValidators.validateFirstName(
              identityControllers.firstNameController,
              notifier,
              identityControllers.firstNameError,
            );
            SignUpHandlers.onFirstNameChanged(value, ref, notifier);
          },
          onSubmitted: (_) => identityControllers.lastNameFocusNode.requestFocus(),
        ),
        GSTextField(
          maxLines: 1,
          label: 'Nom',
          controller: identityControllers.lastNameController,
          focusNode: identityControllers.lastNameFocusNode,
          keyboardActions: TextInputAction.next,
          error: identityControllers.lastNameError.notEmptyOrNull(),
          onValueChange: (value) {
            SignUpValidators.validateLastName(
              identityControllers.lastNameController,
              notifier,
              identityControllers.lastNameError,
            );
            SignUpHandlers.onLastNameChanged(value, ref, notifier);
          },
          onSubmitted: (_) => identityControllers.emailFocusNode.requestFocus(),
        ),
        GSTextField(
          maxLines: 1,
          label: 'Email',
          controller: identityControllers.emailController,
          focusNode: identityControllers.emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          keyboardActions: TextInputAction.go,
          error: identityControllers.emailError.notEmptyOrNull(),
          onValueChange: (value) {
            SignUpValidators.validateEmail(
              identityControllers.emailController,
              notifier,
              identityControllers.emailError,
            );
            SignUpHandlers.onEmailChanged(value, ref, notifier);
          },
          onSubmitted: (_) => onContinue(),
        ),
        GSSpacing.$50.toInt().toHeight,
        SizedBox(
          width: double.infinity,
          child: GSContainerButton.filled(
            padding: const EdgeInsets.symmetric(vertical: GSSpacing.$250),
            enabled: notifier.isCoordinatesFormValid,
            onPressed: onContinue,
            text: 'Continuer',
            gradient: GSColorTokens.primaryGradientHorizontal,
            radius: GSRadius.l,
          ),
        ),
      ],
    );
  }
}

class _PasswordStep extends StatelessWidget {
  const _PasswordStep({
    super.key,
    required this.ref,
    required this.notifier,
    required this.passwordControllers,
    required this.onBack,
    required this.onSubmit,
  });

  final WidgetRef ref;
  final SignUpViewModel notifier;
  final SignUpPasswordControllers passwordControllers;
  final VoidCallback onBack;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: GSSpacing.$200,
      children: [
        _StepIntro(
          title: 'Sécurité',
          description: 'Choisissez un mot de passe solide pour finaliser le compte.',
        ),
        GSPasswordField(
          label: 'Mot de passe',
          controller: passwordControllers.passwordController,
          focusNode: passwordControllers.passwordFocusNode,
          action: TextInputAction.next,
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
        GSPasswordField(
          label: 'Confirmer le mot de passe',
          controller: passwordControllers.confirmPasswordController,
          focusNode: passwordControllers.confirmPasswordFocusNode,
          action: TextInputAction.done,
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
              onSubmit();
            }
          },
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(GSSpacing.$150),
          decoration: BoxDecoration(
            color: GSColorTokens.backgroundPrimary,
            borderRadius: BorderRadius.circular(GSRadius.m),
            border: Border.all(color: GSColorTokens.borderPrimary),
          ),
          child: Text(
            'Le mot de passe doit contenir au moins 12 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial.',
            style: context.bodyDefaultSmall.copyWith(
              color: GSColorTokens.textSecondary,
            ),
          ),
        ),
        GSSpacing.$50.toInt().toHeight,
        Row(
          children: [
            Expanded(
              child: GSContainerButton.outline(
                padding: const EdgeInsets.symmetric(vertical: GSSpacing.$250),
                onPressed: onBack,
                text: 'Retour',
                radius: GSRadius.l,
              ),
            ),
            const SizedBox(width: GSSpacing.$150),
            Expanded(
              child: GSContainerButton.filled(
                padding: const EdgeInsets.symmetric(vertical: GSSpacing.$250),
                isLoading: passwordControllers.isLoading.value,
                enabled: notifier.isFormValid,
                onPressed: onSubmit,
                text: 'S’inscrire',
                gradient: GSColorTokens.primaryGradientHorizontal,
                radius: GSRadius.l,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SignUpProgressHeader extends StatelessWidget {
  const _SignUpProgressHeader({required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: GSSpacing.$150,
      children: [
        Text(
          'Création du compte',
          style: context.bodyAccentSmall.copyWith(
            color: GSColorTokens.textAccent,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _StepIndicator(
                label: 'Identité',
                index: 0,
                currentStep: currentStep,
              ),
            ),
            const SizedBox(width: GSSpacing.$100),
            Expanded(
              child: _StepIndicator(
                label: 'Sécurité',
                index: 1,
                currentStep: currentStep,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({
    required this.label,
    required this.index,
    required this.currentStep,
  });

  final String label;
  final int index;
  final int currentStep;

  @override
  Widget build(BuildContext context) {
    final isActive = currentStep == index;
    final isCompleted = currentStep > index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.$150,
        vertical: GSSpacing.$150,
      ),
      decoration: BoxDecoration(
        color: isActive || isCompleted
            ? GSColors.primary100.withValues(alpha: 0.8)
            : GSColors.neutral050,
        borderRadius: BorderRadius.circular(GSRadius.m),
        border: Border.all(
          color: isActive || isCompleted
              ? GSColorTokens.borderAccent
              : GSColorTokens.borderPrimary,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              gradient: isActive || isCompleted
                  ? GSColorTokens.primaryGradientHorizontal
                  : null,
              color: isActive || isCompleted
                  ? null
                  : GSColorTokens.backgroundDisabled,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: context.captionAccent.copyWith(
                  color: isActive || isCompleted
                      ? GSColorTokens.textInverse
                      : GSColorTokens.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: GSSpacing.$100),
          Expanded(
            child: Text(
              label,
              style: context.bodyDefaultSmall.copyWith(
                color: isActive
                    ? GSColorTokens.textAccent
                    : GSColorTokens.textSecondary,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepIntro extends StatelessWidget {
  const _StepIntro({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodyDefaultMedium.copyWith(
            fontSize: GSFontScale.sf06,
            fontWeight: FontWeight.w700,
            color: GSColorTokens.textPrimary,
          ),
        ),
        const SizedBox(height: GSSpacing.$50),
        Text(
          description,
          style: context.bodyDefaultSmall.copyWith(
            color: GSColorTokens.textSecondary,
          ),
        ),
      ],
    );
  }
}
