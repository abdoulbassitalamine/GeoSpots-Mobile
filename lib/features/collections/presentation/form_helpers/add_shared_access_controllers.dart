import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AddSharedAccessControllers {
  AddSharedAccessControllers({
    required this.urlController,
    required this.tokenController,
    required this.urlFocusNode,
    required this.tokenFocusNode,
    required this.urlError,
    required this.tokenError,
    required this.isImporting,
    required this.submitError,
  });

  final TextEditingController urlController;
  final TextEditingController tokenController;
  final FocusNode urlFocusNode;
  final FocusNode tokenFocusNode;
  final ValueNotifier<String?> urlError;
  final ValueNotifier<String?> tokenError;
  final ValueNotifier<bool> isImporting;
  final ValueNotifier<String?> submitError;

  static AddSharedAccessControllers initialize() {
    return AddSharedAccessControllers(
      urlController: useTextEditingController(),
      tokenController: useTextEditingController(),
      urlFocusNode: useFocusNode(),
      tokenFocusNode: useFocusNode(),
      urlError: useState<String?>(null),
      tokenError: useState<String?>(null),
      isImporting: useState<bool>(false),
      submitError: useState<String?>(null),
    );
  }

  void resetErrors() {
    urlError.value = null;
    tokenError.value = null;
    submitError.value = null;
  }
}
