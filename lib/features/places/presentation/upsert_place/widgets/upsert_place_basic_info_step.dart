import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geo_spots/core/logger/gs_logger.dart';
import 'package:geo_spots/features/places/presentation/view_model/upsert_place_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../../core/utils/extensions/value_notifier_ext.dart';
import '../../../../../../shared/design_system/design_system.dart';
import '../../../../../core/utils/extensions/validators_ext.dart';
import '../../view_model/upsert_place_view_model.dart';

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
        // On passe l'image et les fonctions de rappel (callbacks)
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

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.isEditMode});

  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    return Text(
      isEditMode ? 'Modifiez les informations' : 'Décrivez votre lieu',
      style: GSTypography.bodyDefaultMedium.copyWith(
        color: GSColors.neutral600,
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.imageUrl,
    required this.onPickImage,
    required this.onRemoveImage,
  });

  final String? imageUrl;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Photo (optionnel)', style: GSTypography.labelDefault),
        const SizedBox(height: GSSpacing.m),
        GestureDetector(
          onTap: onPickImage,
          child: Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: GSColors.neutral100,
              borderRadius: BorderRadius.circular(GSRadius.m),
              border: Border.all(
                color: imageUrl != null
                    ? GSColors.primary500
                    : GSColors.neutral300,
                width: imageUrl != null ? 2 : 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(GSRadius.m),
              child: imageUrl != null
                  ? _ImageWithActions(
                      imageUrl: imageUrl!,
                      onRemove: onRemoveImage,
                    )
                  : const _PhotoPlaceholder(),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageWithActions extends StatelessWidget {
  const _ImageWithActions({required this.imageUrl, required this.onRemove});

  final String imageUrl;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _ImagePreview(imageUrl: imageUrl),
        Container(color: GSColors.neutral000.withValues(alpha: 0.1)),
        Positioned(
          top: GSSpacing.s,
          right: GSSpacing.s,
          child: _DeletePhotoButton(onTap: onRemove),
        ),
        const Positioned(
          bottom: GSSpacing.s,
          right: GSSpacing.s,
          child: _EditPhotoBadge(),
        ),
      ],
    );
  }
}

class _DeletePhotoButton extends StatelessWidget {
  const _DeletePhotoButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(GSSpacing.xs),
        decoration: const BoxDecoration(
          color: GSColors.danger600,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.delete_outline,
          color: GSColors.neutral000,
          size: 18,
        ),
      ),
    );
  }
}

class _EditPhotoBadge extends StatelessWidget {
  const _EditPhotoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.m,
        vertical: GSSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: GSColors.neutral000.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(GSRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.edit, size: 14, color: GSColors.neutral800),
          const SizedBox(width: GSSpacing.xs),
          Text(
            'Modifier',
            style: GSTypography.bodyDefaultSmall.copyWith(
              color: GSColors.neutral800,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(GSSpacing.xl),
          decoration: BoxDecoration(
            color: GSColors.neutral200,
            borderRadius: BorderRadius.circular(GSRadius.full),
          ),
          child: const Icon(
            Icons.camera_alt,
            color: GSColors.neutral600,
            size: 32,
          ),
        ),
        const SizedBox(height: GSSpacing.l),
        Text(
          'Appuyez pour ajouter une photo',
          style: GSTypography.bodyDefaultSmall.copyWith(
            color: GSColors.neutral600,
          ),
        ),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.error_outline)),
      );
    } else {
      return Image.file(File(imageUrl), fit: BoxFit.cover);
    }
  }
}

class _LocationInfoBanner extends StatelessWidget {
  const _LocationInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GSSpacing.xl),
      decoration: BoxDecoration(
        color: GSColors.info100,
        borderRadius: BorderRadius.circular(GSRadius.m),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: GSColors.info600, size: 20),
          const SizedBox(width: GSSpacing.m),
          Expanded(
            child: Text(
              'La localisation GPS sera capturée à l\'étape suivante',
              style: GSTypography.bodyDefaultSmall.copyWith(
                color: GSColors.info600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
