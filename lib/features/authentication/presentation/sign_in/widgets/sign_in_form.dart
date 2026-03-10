import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geo_spots/core/utils/extensions/sized_box_extension.dart';
import 'package:geo_spots/core/utils/extensions/value_notifier_ext.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_in_controllers.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_in_handlers.dart';
import 'package:geo_spots/features/authentication/presentation/form_helpers/sign_in_validators.dart';
import 'package:geo_spots/features/authentication/presentation/route/route_data.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_in/sign_in_view_model.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(signInViewModelProvider.notifier);
    final controllers = SignInControllers.initialize();

    SignInValidators.setupValidatorMessages(context, notifier);
    SignInValidators.setupInitialValidation(ref, notifier, controllers);
    SignInValidators.setupAllFocusListeners(controllers, notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GSTextField(
          maxLines: 1,
          label: 'Email',
          controller: controllers.emailController,
          focusNode: controllers.emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          error: controllers.emailError.notEmptyOrNull(),
          enabled: !controllers.isLoading.value,
          onValueChange: (value) {
            SignInHandlers.onEmailChanged(value, ref, notifier);
          },
          onSubmitted: (_) => controllers.passwordFocusNode.requestFocus(),
        ),
        const SizedBox(height: GSSpacing.$200),
        GSPasswordField(
          label: 'Mot de passe',
          controller: controllers.passwordController,
          focusNode: controllers.passwordFocusNode,
          error: controllers.passwordError.notEmptyOrNull(),
          obscureText: controllers.hiddenPassword.value,
          onVisibilityChanged: (value) => controllers.hiddenPassword.value = value,
          onChanged: (value) {
            SignInHandlers.onPasswordChanged(value, ref, notifier);
          },
          onSubmitted: (_) {
            if (controllers.emailError.value == null &&
                controllers.passwordError.value == null) {
              SignInHandlers.onSubmit(ref, context, controllers);
            }
          },
        ),
        GSSpacing.$150.toInt().toHeight,
        _ForgotPasswordLink(
          onClick: () => const ForgotPasswordRouteData().go(context),
        ),
        const SizedBox(height: GSSpacing.$600),
        Consumer(
          builder: (context, ref, _) {
            ref.watch(signInViewModelProvider);
            return GSContainerButton.filled(
              padding: const EdgeInsets.symmetric(vertical: GSSpacing.$250),
              isLoading: controllers.isLoading.value,
              onPressed: () => SignInHandlers.onSubmit(ref, context, controllers),
              text: 'Se connecter',
              enabled: notifier.isFormValid,
              gradient: GSColorTokens.primaryGradientHorizontal,
              radius: GSRadius.l,
            );
          },
        ),
        GSSpacing.$300.toInt().toHeight,
        _SignupLink(onClick: () => const SignUpRouteData().go(context)),
      ],
    );
  }
}

class _ForgotPasswordLink extends StatelessWidget {
  const _ForgotPasswordLink({required this.onClick});

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.end,
        text: TextSpan(
          text: 'Mot de passe oublié ?',
          style: context.bodyAccentSmall.copyWith(
            color: GSColors.neutral900,
            fontWeight: FontWeight.w400,
          ),
          recognizer: TapGestureRecognizer()..onTap = onClick,
        ),
      ),
    );
  }
}

class _SignupLink extends StatelessWidget {
  const _SignupLink({required this.onClick});

  final VoidCallback onClick;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Vous n’avez pas de compte ? ',
          style: context.bodyAccentSmall.copyWith(
            color: GSColors.neutral900,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: 'Créer un compte',
              style: context.bodyAccentSmall.copyWith(
                color: GSColors.neutral900,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = onClick,
            ),
          ],
        ),
      ),
    );
  }
}
