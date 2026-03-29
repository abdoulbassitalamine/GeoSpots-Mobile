import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';

import '../view_model/add_shared_access/add_shared_access_view_model.dart';
import 'add_shared_access_controllers.dart';

class AddSharedAccessValidators {
  static void setupValidatorMessages(AddSharedAccessViewModel notifier) {
    notifier.setupValidatorMessages();
  }

  static void setupAllFocusListeners(
    AddSharedAccessControllers controllers,
    AddSharedAccessViewModel notifier,
  ) {
    useEffect(() {
      void handleUrlFocus() {
        if (controllers.urlFocusNode.hasFocus) {
          controllers.urlError.value = null;
        } else {
          validateUrl(controllers.urlController, notifier, controllers.urlError);
        }
      }

      void handleTokenFocus() {
        if (controllers.tokenFocusNode.hasFocus) {
          controllers.tokenError.value = null;
        } else {
          validateToken(
            controllers.tokenController,
            notifier,
            controllers.tokenError,
          );
        }
      }

      controllers.urlFocusNode.addListener(handleUrlFocus);
      controllers.tokenFocusNode.addListener(handleTokenFocus);

      return () {
        controllers.urlFocusNode.removeListener(handleUrlFocus);
        controllers.tokenFocusNode.removeListener(handleTokenFocus);
      };
    }, const []);
  }

  static void validateUrl(
    TextEditingController controller,
    AddSharedAccessViewModel notifier,
    ValueNotifier<String?> error,
  ) {
    if (controller.text.isEmpty) {
      error.value = null;
      return;
    }
    error.value = notifier.urlValidators
        .executeWithPriorityMessage(controller.text)
        .message;
  }

  static void validateToken(
    TextEditingController controller,
    AddSharedAccessViewModel notifier,
    ValueNotifier<String?> error,
  ) {
    if (controller.text.isEmpty) {
      error.value = null;
      return;
    }
    error.value = notifier.tokenValidators
        .executeWithPriorityMessage(controller.text)
        .message;
  }
}
