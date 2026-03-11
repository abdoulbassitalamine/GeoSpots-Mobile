import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/utils/extensions/validators_ext.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/design_system/design_system.dart';
import '../../form_helpers/add_shared_access_handlers.dart';
import '../../form_helpers/add_shared_access_validators.dart';
import '../../view_model/collections_view_model.dart';

class AddSharedAccessDialog extends HookConsumerWidget {
  const AddSharedAccessDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlController = useTextEditingController();
    final tokenController = useTextEditingController();
    final urlFocusNode = useFocusNode();
    final tokenFocusNode = useFocusNode();
    final urlError = useState<String?>(null);
    final tokenError = useState<String?>(null);
    final isImporting = useState(false);
    final submitError = useState<String?>(null);

    AddSharedAccessValidators.setupMessages();
    AddSharedAccessValidators.setupFocusListeners(
      urlController: urlController,
      tokenController: tokenController,
      urlFocusNode: urlFocusNode,
      tokenFocusNode: tokenFocusNode,
      urlError: urlError,
      tokenError: tokenError,
    );

    final isFormValid =
        AddSharedAccessValidators.urlValidators
            .executeWithPriorityMessage(urlController.text)
            .isValid &&
        AddSharedAccessValidators.tokenValidators
            .executeWithPriorityMessage(tokenController.text)
            .isValid;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        title: Text(
          'Ajouter un accès partagé',
          style: GSTypography.headingSmall,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GSTextField(
              controller: urlController,
              focusNode: urlFocusNode,
              label: 'URL du service',
              placeholder: 'https://api.exemple.com',
              errorMessage: urlError.value,
              onValueChange: (_) => submitError.value = null,
            ),
            const SizedBox(height: GSSpacing.m),
            GSTextField(
              controller: tokenController,
              focusNode: tokenFocusNode,
              label: 'Token',
              placeholder: 'Collez le token partagé',
              errorMessage: tokenError.value,
              onValueChange: (_) => submitError.value = null,
            ),
            if (submitError.value != null) ...[
              const SizedBox(height: GSSpacing.m),
              Text(
                submitError.value!,
                style: GSTypography.bodyDefaultSmall.copyWith(
                  color: GSColors.danger600,
                ),
              ),
            ],
            const SizedBox(height: GSSpacing.m),
            GSActionButtonRow(
              cancelText: 'Annuler',
              saveText: 'Valider',
              isFormValid: !isImporting.value && isFormValid,
              isLoading: isImporting.value,
              onCancel: () {
                ref.read(collectionsViewModelProvider.notifier).clearError();
                Navigator.of(context).pop();
              },
              onSave: () => AddSharedAccessHandlers.onSubmit(
                ref: ref,
                context: context,
                urlController: urlController,
                tokenController: tokenController,
                isImporting: isImporting,
                submitError: submitError,
                isFormValid: isFormValid,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
