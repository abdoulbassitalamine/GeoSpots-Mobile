import 'package:flutter/material.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/add_shared_access/add_shared_access_view_model.dart';
import '../view_model/collections_view_model.dart';
import 'add_shared_access_controllers.dart';

class AddSharedAccessHandlers {
  static void onUrlChanged(
    String value,
    WidgetRef ref,
    AddSharedAccessViewModel notifier,
  ) {
    notifier.updateState(
      ref.read(addSharedAccessViewModelProvider).copyWith(url: value),
    );
  }

  static void onTokenChanged(
    String value,
    WidgetRef ref,
    AddSharedAccessViewModel notifier,
  ) {
    notifier.updateState(
      ref.read(addSharedAccessViewModelProvider).copyWith(token: value),
    );
  }

  static Future<void> onSubmit({
    required WidgetRef ref,
    required BuildContext context,
    required AddSharedAccessControllers controllers,
  }) async {
    if (controllers.isImporting.value) return;

    controllers.isImporting.value = true;
    controllers.submitError.value = null;
    FocusScope.of(context).unfocus();
    controllers.resetErrors();

    final state = ref.read(addSharedAccessViewModelProvider);
    final notifier = ref.read(addSharedAccessViewModelProvider.notifier);

    final urlValidation = notifier.urlValidators
        .executeWithPriorityMessage(state.url)
        .message;
    final tokenValidation = notifier.tokenValidators
        .executeWithPriorityMessage(state.token)
        .message;

    if (urlValidation != null || tokenValidation != null) {
      controllers.urlError.value = urlValidation;
      controllers.tokenError.value = tokenValidation;
      controllers.isImporting.value = false;
      return;
    }

    final navigator = Navigator.of(context);
    final collectionsNotifier = ref.read(collectionsViewModelProvider.notifier);

    final success = await collectionsNotifier.importSharedAccess(
      baseUrl: state.url,
      token: state.token,
    );

    if (!context.mounted) return;

    if (success) {
      navigator.pop();
      return;
    }

    controllers.isImporting.value = false;
    controllers.submitError.value =
        ref.read(collectionsViewModelProvider).error ??
        'Impossible d\'ajouter cet accès partagé';
  }
}
