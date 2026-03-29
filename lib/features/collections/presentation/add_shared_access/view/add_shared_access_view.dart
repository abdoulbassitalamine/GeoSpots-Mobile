import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/design_system/design_system.dart';
import '../../form_helpers/add_shared_access_controllers.dart';
import '../../form_helpers/add_shared_access_handlers.dart';
import '../../form_helpers/add_shared_access_validators.dart';
import '../../view_model/add_shared_access/add_shared_access_view_model.dart';
import 'widgets/add_shared_access_header.dart';

class AddSharedAccessView extends HookConsumerWidget {
  const AddSharedAccessView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(addSharedAccessViewModelProvider.notifier);
    final controllers = AddSharedAccessControllers.initialize();

    AddSharedAccessValidators.setupValidatorMessages(notifier);
    AddSharedAccessValidators.setupAllFocusListeners(controllers, notifier);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: [
          const AddSharedAccessHeader(
            title: 'Accès partagé',
            subtitle:
                'Ajoutez une collection existante partagée par un collègue ou un ami via un lien et un token dédiés.',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(GSSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GSTextField(
                    controller: controllers.urlController,
                    focusNode: controllers.urlFocusNode,
                    label: 'URL de la ressource',
                    placeholder: 'http://serveur/api/collections/1',
                    errorMessage: controllers.urlError.value,
                    onValueChange: (value) {
                      controllers.submitError.value = null;
                      AddSharedAccessHandlers.onUrlChanged(value, ref, notifier);
                    },
                  ),
                  const SizedBox(height: GSSpacing.xl),
                  GSTextField(
                    controller: controllers.tokenController,
                    focusNode: controllers.tokenFocusNode,
                    label: 'Token',
                    placeholder: 'Collez le token partagé',
                    errorMessage: controllers.tokenError.value,
                    onValueChange: (value) {
                      controllers.submitError.value = null;
                      AddSharedAccessHandlers.onTokenChanged(
                        value,
                        ref,
                        notifier,
                      );
                    },
                  ),
                  if (controllers.submitError.value != null) ...[
                    const SizedBox(height: GSSpacing.m),
                    Text(
                      controllers.submitError.value!,
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.danger600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GSSpacing.xl,
                vertical: GSSpacing.l,
              ),
              child: Consumer(
                builder: (context, ref, _) {
                  ref.watch(addSharedAccessViewModelProvider);
                  return GSFilledButton(
                    text: 'Valider',
                    fullWidth: true,
                    enabled: !controllers.isImporting.value && notifier.isFormValid,
                    onPressed: () => AddSharedAccessHandlers.onSubmit(
                      ref: ref,
                      context: context,
                      controllers: controllers,
                    ),
                    isLoading: controllers.isImporting.value,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
