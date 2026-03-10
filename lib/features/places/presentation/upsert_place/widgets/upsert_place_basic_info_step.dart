import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/features/places/presentation/view_model/upsert_place_state.dart';
import '../../../../../../core/utils/extensions/value_notifier_ext.dart';
import '../../../../../../shared/design_system/design_system.dart';
import '../../../../../core/utils/extensions/validators_ext.dart';
import '../../view_model/upsert_place_view_model.dart';

part 'upsert_place_basic_info_step_chrome.dart';
part 'upsert_place_basic_info_step_photo.dart';

class UpsertPlaceBasicInfoStepView extends HookWidget {
  const UpsertPlaceBasicInfoStepView({
    super.key,
    required this.state,
    required this.notifier,
  });

  final UpsertPlaceState state;
  final UpsertPlaceViewModel notifier;

  @override
  Widget build(BuildContext context) {
    final titleController = useTextEditingController(text: state.title);
    final titleError = useState<String?>(null);

    final descriptionController = useTextEditingController(
      text: state.description,
    );

    useEffect(() {
      notifier.requiredValidator.withErrorMessage('Ce champ est obligatoire');

      if (titleController.text.isNotEmpty) {
        titleError.value = notifier.titleValidators
            .executeWithPriorityMessage(titleController.text)
            .message;
      }
      return null;
    }, const []);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(isEditMode: state.isEditMode),
        SizedBox(height: GSSpacing.xl3),
        GSTextField(
          label: 'Titre du lieu',
          placeholder: 'Ex: Restaurant Le Jardin',
          controller: titleController,
          error: titleError.notEmptyOrNull(),
          onValueChange: (value) {
            titleError.value = notifier.titleValidators
                .executeWithPriorityMessage(value)
                .message;
            notifier.updateState(state.copyWith(title: value));
          },
        ),
        SizedBox(height: GSSpacing.xl),
        GSTextField(
          label: 'Description',
          placeholder: 'Ajoutez une description...',
          controller: descriptionController,
          maxLines: 4,
          onValueChange: (value) {
            notifier.updateState(state.copyWith(description: value));
          },
        ),
        SizedBox(height: GSSpacing.xl),
        _PhotoSection(
          imageUrl: state.imageUrl,
          onPickImage: notifier.pickImage,
          onRemoveImage: () =>
              notifier.updateState(state.copyWith(imageUrl: null)),
        ),
        SizedBox(height: GSSpacing.xl),
        const _LocationInfoBanner(),
      ],
    );
  }
}
