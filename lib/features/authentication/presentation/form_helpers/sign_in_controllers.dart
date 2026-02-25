import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignInControllers {
  SignInControllers({
    required this.emailController,
    required this.passwordController,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.emailError,
    required this.passwordError,
    required this.hiddenPassword,
    required this.isLoading,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final ValueNotifier<String?> emailError;
  final ValueNotifier<String?> passwordError;
  final ValueNotifier<bool> hiddenPassword;
  final ValueNotifier<bool> isLoading;

  static SignInControllers initialize() {
    return SignInControllers(
      emailController: useTextEditingController(),
      passwordController: useTextEditingController(),
      emailFocusNode: useFocusNode(),
      passwordFocusNode: useFocusNode(),
      emailError: useState<String?>(null),
      passwordError: useState<String?>(null),
      hiddenPassword: useState<bool>(true),
      isLoading: useState<bool>(false),
    );
  }

  void resetErrors() {
    emailError.value = null;
    passwordError.value = null;
  }
}
