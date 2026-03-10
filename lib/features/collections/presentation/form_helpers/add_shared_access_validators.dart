import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:geo_spots/core/utils/validator/validator.dart';

class AddSharedAccessValidators {
  static final _requiredValidator = ValidatorRequired();
  static final _urlValidator = ValidatorUrl();

  static final urlValidators = Validators(
    validators: [_requiredValidator, _urlValidator],
  );
  static final tokenValidators = Validators(
    validators: [_requiredValidator],
  );

  static void setupMessages() {
    _requiredValidator.withErrorMessage('Champ requis');
    _urlValidator.withErrorMessage('URL invalide');
  }

  static void setupFocusListeners({
    required TextEditingController urlController,
    required TextEditingController tokenController,
    required FocusNode urlFocusNode,
    required FocusNode tokenFocusNode,
    required ValueNotifier<String?> urlError,
    required ValueNotifier<String?> tokenError,
  }) {
    useEffect(() {
      void handleUrlFocus() {
        if (urlFocusNode.hasFocus) {
          urlError.value = null;
        } else {
          _validateField(urlController, urlValidators, urlError);
        }
      }

      void handleTokenFocus() {
        if (tokenFocusNode.hasFocus) {
          tokenError.value = null;
        } else {
          _validateField(tokenController, tokenValidators, tokenError);
        }
      }

      urlFocusNode.addListener(handleUrlFocus);
      tokenFocusNode.addListener(handleTokenFocus);

      return () {
        urlFocusNode.removeListener(handleUrlFocus);
        tokenFocusNode.removeListener(handleTokenFocus);
      };
    }, const []);
  }

  static void _validateField(
    TextEditingController controller,
    Validators validators,
    ValueNotifier<String?> error,
  ) {
    if (controller.text.isEmpty) {
      error.value = null;
      return;
    }
    error.value = validators.executeWithPriorityMessage(controller.text).message;
  }
}
