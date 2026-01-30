import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/logger/gs_logger.dart';
import '../../../../../core/router/route_names.dart';
import '../../../../../core/utils/extensions/sized_box_extension.dart';
import '../../../../../core/utils/extensions/validators_ext.dart';
import '../../../../../core/utils/extensions/value_notifier_ext.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../data/exception/auth_exception.dart';
import '../../view_model/authentication_view_model.dart';
import '../../view_model/sign_in/sign_in_view_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(signInViewModelProvider.notifier);

    // Set validator messages
    notifier.requiredValidator.withErrorMessage('Ce champ est obligatoire');
    notifier.emailValidator.withErrorMessage('Veuillez saisir un email valide');

    // Email
    final emailController = useTextEditingController();
    final emailFocusNode = useFocusNode();
    final emailError = useState<String?>(null);

    // Password
    final passwordController = useTextEditingController();
    final passwordFocusNode = useFocusNode();
    final passwordError = useState<String?>(null);

    final hiddenPassword = useState<bool>(true);
    final isLoading = useState<bool>(false);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (emailController.text.isNotEmpty) {
          emailError.value = notifier.emailValidators
              .executeWithPriorityMessage(emailController.text)
              .message;
        }
        if (passwordController.text.isNotEmpty) {
          passwordError.value = notifier.passwordValidators
              .executeWithPriorityMessage(passwordController.text)
              .message;
        }
        final updatedSignInState = ref
            .read(signInViewModelProvider)
            .copyWith(
              password: passwordController.text,
              email: emailController.text,
            );
        notifier.updateState(updatedSignInState);
      });
      return null;
    }, []);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GSTextField(
          maxLines: 1,
          label: 'Email',
          controller: emailController,
          focusNode: emailFocusNode,
          keyboardType: TextInputType.emailAddress,
          error: emailError.notEmptyOrNull(),
          onValueChange: (value) {
            emailError.value = notifier.emailValidators
                .executeWithPriorityMessage(value)
                .message;
            final updatedSignInState = ref
                .read(signInViewModelProvider)
                .copyWith(email: value);
            notifier.updateState(updatedSignInState);
          },
          onSubmitted: (_) => passwordFocusNode.requestFocus(),
        ),
        const SizedBox(height: GSSpacing.$200),
        GSPasswordField(
          label: 'Mot de passe',
          controller: passwordController,
          focusNode: passwordFocusNode,
          error: passwordError.notEmptyOrNull(),
          obscureText: hiddenPassword.value,
          onVisibilityChanged: (value) => hiddenPassword.value = value,
          onChanged: (value) {
            passwordError.value = notifier.passwordValidators
                .executeWithPriorityMessage(value)
                .message;
            final updatedSignInState = ref
                .read(signInViewModelProvider)
                .copyWith(password: value);
            notifier.updateState(updatedSignInState);
          },
          onSubmitted: (_) {
            if (emailError.value == null && passwordError.value == null) {
              _onSubmit(
                ref,
                context,
                isLoading: isLoading,
                emailError: emailError,
                passwordError: passwordError,
              );
            }
          },
        ),
        GSSpacing.$200.toInt().toHeight,
        _ForgotPasswordLink(
          onClick: () {
            context.pushNamed(RouteNames.forgotPassword);
          },
        ),
        const SizedBox(height: GSSpacing.$600),

        Consumer(
          builder: (context, ref, _) {
            ref.watch(signInViewModelProvider);

            return Column(
              spacing: GSSpacing.$150,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GSContainerButton.filled(
                  padding: const EdgeInsets.symmetric(vertical: GSSpacing.$250),
                  isLoading: isLoading.value,
                  onPressed: () => _onSubmit(
                    ref,
                    context,
                    isLoading: isLoading,
                    emailError: emailError,
                    passwordError: passwordError,
                  ),
                  text: 'Se connecter',
                  enabled: notifier.isFormValid,
                  gradient: GSColorTokens.primaryGradientHorizontal,
                  radius: GSRadius.l,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<void> _onSubmit(
    WidgetRef ref,
    BuildContext context, {
    required ValueNotifier<bool> isLoading,
    required ValueNotifier<String?> emailError,
    required ValueNotifier<String?> passwordError,
  }) async {
    if (isLoading.value) {
      return;
    }
    isLoading.value = true;
    FocusScope.of(context).requestFocus(FocusNode());

    // Reset errors
    emailError.clear();
    passwordError.clear();

    final signInForm = ref.read(signInViewModelProvider);

    try {
      // await ref
      //     .read(authenticationViewModelProvider.notifier)
      //     .signIn(mail: signInForm.email, password: signInForm.password);

      context.goNamed(RouteNames.homeName);

      isLoading.value = false;
      return;
    } on Exception catch (error) {
      if (!context.mounted) return;
      GsLogger().e(error);

      if (error is WrongEmailOrPasswordException) {
        passwordError.value = 'Email ou mot de passe incorrect.';
        emailError.value = ' ';
      } else {
        showTopSnackBar(
          Overlay.of(context),
          snackBarPosition: SnackBarPosition.bottom,
          CustomSnackBar.error(message: 'Veuillez réessayer plus tard.'),
        );
      }
    } finally {
      isLoading.value = false;
    }
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
