import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/design_system/design_system.dart';
import '../../view_model/collections_view_model.dart';

typedef AddSharedAccessValidator = String? Function(String value);

String? _defaultBaseUrlValidator(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return 'URL requise';
  }

  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    return 'URL invalide';
  }

  return null;
}

String? _defaultTokenValidator(String value) {
  if (value.trim().isEmpty) {
    return 'Token requis';
  }
  return null;
}

class AddSharedAccessDialog extends HookConsumerWidget {
  const AddSharedAccessDialog({
    super.key,
    this.baseUrlValidator = _defaultBaseUrlValidator,
    this.tokenValidator = _defaultTokenValidator,
  });

  final AddSharedAccessValidator baseUrlValidator;
  final AddSharedAccessValidator tokenValidator;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urlController = useTextEditingController();
    final tokenController = useTextEditingController();
    final isImporting = useState(false);
    final error = useState<String?>(null);
    final notifier = ref.read(collectionsViewModelProvider.notifier);
    final baseUrlError = baseUrlValidator(urlController.text);
    final tokenError = tokenValidator(tokenController.text);
    final isFormValid = baseUrlError == null && tokenError == null;

    useEffect(() {
      notifier.clearError();
      return null;
    }, const []);

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
              label: 'URL du service',
              placeholder: 'https://api.exemple.com',
              errorMessage: baseUrlError,
              onValueChange: (_) {
                error.value = null;
                notifier.clearError();
              },
            ),
            const SizedBox(height: GSSpacing.m),
            GSTextField(
              controller: tokenController,
              label: 'Token',
              placeholder: 'Collez le token partagé',
              errorMessage: tokenError,
              onValueChange: (_) {
                error.value = null;
                notifier.clearError();
              },
            ),
            if (error.value != null) ...[
              const SizedBox(height: GSSpacing.m),
              Text(
                error.value!,
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
                notifier.clearError();
                Navigator.of(context).pop();
              },
              onSave: () async {
                if (!isFormValid) {
                  return;
                }
                isImporting.value = true;
                error.value = null;
                final navigator = Navigator.of(context);
                final success = await notifier.importSharedAccess(
                  baseUrl: urlController.text,
                  token: tokenController.text,
                );
                if (!context.mounted) {
                  return;
                }
                if (success) {
                  navigator.pop();
                  return;
                }
                isImporting.value = false;
                error.value =
                    ref.read(collectionsViewModelProvider).error ??
                    'Impossible d\'ajouter cet accès partagé';
              },
            ),
          ],
        ),
      ),
    );
  }
}
