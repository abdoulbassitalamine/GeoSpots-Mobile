import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/features/authentication/presentation/route/route_data.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_up/sign_up_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../core/logger/gs_logger.dart';
import '../../../../../core/utils/extensions/sized_box_extension.dart';
import '../../../../../core/utils/extensions/validators_ext.dart';
import '../../../../../core/utils/extensions/value_notifier_ext.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../data/exception/auth_exception.dart';
import '../../view_model/authentication_view_model.dart';

class SignupForm extends HookConsumerWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(signUpViewModelProvider.notifier);
    final signupState = ref.watch(signUpViewModelProvider);
    final isLoading = useState<bool>(false);

    // Set validator messages
    notifier.setupValidatorMessages(context);

    // First Name
    final firstNameController = useTextEditingController();
    final firstNameFocusNode = useFocusNode();
    final firstNameError = useState<String?>(null);

    // Last Name
    final lastNameController = useTextEditingController();
    final lastNameFocusNode = useFocusNode();
    final lastNameError = useState<String?>(null);

    // Email
    final emailController = useTextEditingController();
    final emailFocusNode = useFocusNode();
    final emailError = useState<String?>(null);

    // Password
    final passwordController = useTextEditingController();
    final passwordFocusNode = useFocusNode();
    final passwordError = useState<String?>(null);

    // Confirm Password
    final confirmPasswordController = useTextEditingController();
    final confirmPasswordFocusNode = useFocusNode();
    final confirmPasswordError = useState<String?>(null);

    final hiddenPassword = useState<bool>(true);
    final hiddenConfirmPassword = useState<bool>(true);

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
            .read(signUpViewModelProvider)
            .copyWith(
              password: passwordController.text,
              email: emailController.text,
            );
        notifier.updateState(updatedSignInState);
      });
      return null;
    }, []);

    return Column(
      spacing: GSSpacing.$200,
      children: [
        GSInlineTextField(
          label: 'Prénom',
          controller: firstNameController,
          focusNode: firstNameFocusNode,
          error: firstNameError.notEmptyOrNull(),
          onChanged: (value) {
            firstNameError.value = notifier.firstNameValidators
                .executeWithPriorityMessage(value)
                .message;
            notifier.updateState(signupState.copyWith(firstName: value));
          },
          onSubmitted: (_) => lastNameFocusNode.requestFocus(),
        ),
        GSInlineTextField(
          label: 'Nom',
          controller: lastNameController,
          focusNode: lastNameFocusNode,
          error: lastNameError.notEmptyOrNull(),
          onChanged: (value) {
            lastNameError.value = notifier.lastNameValidators
                .executeWithPriorityMessage(value)
                .message;
            notifier.updateState(signupState.copyWith(lastName: value));
          },
          onSubmitted: (_) => emailFocusNode.requestFocus(),
        ),
        GSInlineTextField(
          label: 'Email',
          controller: emailController,
          focusNode: emailFocusNode,
          error: emailError.notEmptyOrNull(),
          onChanged: (value) {
            emailError.value = notifier.emailValidators
                .executeWithPriorityMessage(value)
                .message;
            notifier.updateState(signupState.copyWith(email: value));
          },
          onSubmitted: (_) => passwordFocusNode.requestFocus(),
        ),
        GSInlinePasswordField(
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
            notifier.updateState(signupState.copyWith(password: value));
          },
          onSubmitted: (_) => confirmPasswordFocusNode.requestFocus(),
        ),
        GSInlinePasswordField(
          label: 'Confirmer le mot de passe',
          controller: confirmPasswordController,
          focusNode: confirmPasswordFocusNode,
          obscureText: hiddenConfirmPassword.value,
          error: confirmPasswordError.notEmptyOrNull(),
          onVisibilityChanged: (value) => hiddenConfirmPassword.value = value,
          onChanged: (value) {
            confirmPasswordError.value = notifier.confirmPasswordValidators
                .executeWithPriorityMessage(value)
                .message;
            notifier.updateState(signupState.copyWith(confirmPassword: value));
          },
          onSubmitted: (_) {
            if (firstNameError.value == null &&
                lastNameError.value == null &&
                emailError.value == null &&
                passwordError.value == null &&
                confirmPasswordError.value == null) {
              _onSubmit(
                ref,
                context,
                isLoading: isLoading,
                firstNameError: firstNameError,
                lastNameError: lastNameError,
                emailError: emailError,
                passwordError: passwordError,
                confirmPasswordError: confirmPasswordError,
              );
            }
          },
        ),
        GSSpacing.$50.toInt().toHeight,
        Text.rich(
          TextSpan(
            text:
                'En continuant, vous acceptez nos conditions d\'utilisation et notre politique de confidentialité',
            style: context.bodyAccentSmall.copyWith(
              fontWeight: FontWeight.w400,
              letterSpacing: 0.05,
              color: GSColorTokens.textPrimary.withValues(alpha: .7),
            ),
          ),
        ),
        GSSpacing.$50.toInt().toHeight,
        GSContainerButton.filled(
          padding: const EdgeInsets.symmetric(vertical: GSSpacing.$250),
          isLoading: isLoading.value,
          enabled: notifier.isFormValid,
          onPressed: () => _onSubmit(
            ref,
            context,
            isLoading: isLoading,
            firstNameError: firstNameError,
            lastNameError: lastNameError,
            emailError: emailError,
            passwordError: passwordError,
            confirmPasswordError: confirmPasswordError,
          ),
          text: 'S\'inscrire',
          gradient: GSColorTokens.primaryGradientHorizontal,
          radius: GSRadius.l,
        ),
      ],
    );
  }
}

void _onSubmit(
  WidgetRef ref,
  BuildContext context, {
  required ValueNotifier<bool> isLoading,
  required ValueNotifier<String?> firstNameError,
  required ValueNotifier<String?> lastNameError,
  required ValueNotifier<String?> emailError,
  required ValueNotifier<String?> passwordError,
  required ValueNotifier<String?> confirmPasswordError,
}) async {
  if (isLoading.value) {
    return;
  }
  isLoading.value = true;
  FocusScope.of(context).requestFocus(FocusNode());

  // Reset errors
  firstNameError.clear();
  lastNameError.clear();
  emailError.clear();
  passwordError.clear();
  confirmPasswordError.clear();

  final signInForm = ref.read(signUpViewModelProvider);

  try {
    await ref
        .read(authenticationViewModelProvider.notifier)
        .signUp(
          firstName: signInForm.firstName,
          lastName: signInForm.lastName,
          mail: signInForm.email,
          password: signInForm.password,
          passwordConfirmation: signInForm.confirmPassword,
        );
    if (context.mounted) {
      const SignInRouteData().push(context);
    }
  } on Exception catch (error) {
    if (!context.mounted) return;
    GsLogger().e(error);

    if (error is EmailAlreadyExistsException) {
      emailError.value = 'Cet email est déjà utilisé';
      if (context.mounted) {
        showTopSnackBar(
          Overlay.of(context),
          snackBarPosition: SnackBarPosition.bottom,
          CustomSnackBar.error(message: 'Cet email est déjà utilisé'),
        );
      }
    } else if (error is SignUpServerException) {
      showTopSnackBar(
        Overlay.of(context),
        snackBarPosition: SnackBarPosition.bottom,
        CustomSnackBar.error(message: 'Erreur du serveur'),
      );
    } else {
      showTopSnackBar(
        Overlay.of(context),
        snackBarPosition: SnackBarPosition.bottom,
        CustomSnackBar.error(message: 'Veuillez réessayer plus tard'),
      );
    }
  } finally {
    isLoading.value = false;
  }
}
