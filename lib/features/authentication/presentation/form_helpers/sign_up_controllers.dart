import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/features/authentication/presentation/view_model/sign_up/sign_up_state.dart';

class SignUpIdentityControllers {
  SignUpIdentityControllers({
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.firstNameFocusNode,
    required this.lastNameFocusNode,
    required this.emailFocusNode,
    required this.firstNameError,
    required this.lastNameError,
    required this.emailError,
  });

  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final FocusNode firstNameFocusNode;
  final FocusNode lastNameFocusNode;
  final FocusNode emailFocusNode;
  final ValueNotifier<String?> firstNameError;
  final ValueNotifier<String?> lastNameError;
  final ValueNotifier<String?> emailError;

  static SignUpIdentityControllers initialize(SignUpState state) {
    return SignUpIdentityControllers(
      firstNameController: useTextEditingController(text: state.firstName),
      lastNameController: useTextEditingController(text: state.lastName),
      emailController: useTextEditingController(text: state.email),
      firstNameFocusNode: useFocusNode(),
      lastNameFocusNode: useFocusNode(),
      emailFocusNode: useFocusNode(),
      firstNameError: useState<String?>(null),
      lastNameError: useState<String?>(null),
      emailError: useState<String?>(null),
    );
  }
}

class SignUpPasswordControllers {
  SignUpPasswordControllers({
    required this.passwordController,
    required this.confirmPasswordController,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.passwordError,
    required this.confirmPasswordError,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.isLoading,
  });

  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final ValueNotifier<String?> passwordError;
  final ValueNotifier<String?> confirmPasswordError;
  final ValueNotifier<bool> isPasswordVisible;
  final ValueNotifier<bool> isConfirmPasswordVisible;
  final ValueNotifier<bool> isLoading;

  static SignUpPasswordControllers initialize(SignUpState state) {
    return SignUpPasswordControllers(
      passwordController: useTextEditingController(text: state.password),
      confirmPasswordController: useTextEditingController(
        text: state.confirmPassword,
      ),
      passwordFocusNode: useFocusNode(),
      confirmPasswordFocusNode: useFocusNode(),
      passwordError: useState<String?>(null),
      confirmPasswordError: useState<String?>(null),
      isPasswordVisible: useState<bool>(false),
      isConfirmPasswordVisible: useState<bool>(false),
      isLoading: useState<bool>(false),
    );
  }

  void resetErrors() {
    passwordError.value = null;
    confirmPasswordError.value = null;
  }
}
