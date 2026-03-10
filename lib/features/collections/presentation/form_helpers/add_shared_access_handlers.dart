import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model/collections_view_model.dart';

class AddSharedAccessHandlers {
  static Future<void> onSubmit({
    required WidgetRef ref,
    required BuildContext context,
    required TextEditingController urlController,
    required TextEditingController tokenController,
    required ValueNotifier<bool> isImporting,
    required ValueNotifier<String?> submitError,
    required bool isFormValid,
  }) async {
    if (!isFormValid) return;

    isImporting.value = true;
    submitError.value = null;

    final navigator = Navigator.of(context);
    final notifier = ref.read(collectionsViewModelProvider.notifier);

    final success = await notifier.importSharedAccess(
      baseUrl: urlController.text,
      token: tokenController.text,
    );

    if (!context.mounted) return;

    if (success) {
      navigator.pop();
      return;
    }

    isImporting.value = false;
    submitError.value =
        ref.read(collectionsViewModelProvider).error ??
        'Impossible d\'ajouter cet accès partagé';
  }
}
