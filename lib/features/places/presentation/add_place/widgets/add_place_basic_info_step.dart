import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../../core/utils/extensions/value_notifier_ext.dart';
import '../../../../../../shared/design_system/design_system.dart';
import '../../../../../core/utils/extensions/validators_ext.dart';
import '../../view_model/add_place_view_model.dart';

class AddPlaceBasicInfoStepView extends HookConsumerWidget {
  const AddPlaceBasicInfoStepView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeader(),
        SizedBox(height: GSSpacing.xl3),
        _TitleField(),
        SizedBox(height: GSSpacing.xl),
        _DescriptionField(),
        SizedBox(height: GSSpacing.xl),
        _PhotoSectionWrapper(),
        SizedBox(height: GSSpacing.xl),
        _LocationInfoBanner(),
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Décrivez votre lieu',
      style: GSTypography.bodyDefaultMedium.copyWith(
        color: GSColors.neutral600,
      ),
    );
  }
}

class _TitleField extends HookConsumerWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addPlaceViewModelProvider);
    final notifier = ref.read(addPlaceViewModelProvider.notifier);

    final titleController = useTextEditingController(text: state.title);
    final titleError = useState<String?>(null);

    useEffect(() {
      if (titleController.text.isNotEmpty) {
        titleError.value = notifier.titleValidators
            .executeWithPriorityMessage(titleController.text)
            .message;
      }
      return null;
    }, const []);

    return GSTextField(
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
    );
  }
}

class _DescriptionField extends HookConsumerWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addPlaceViewModelProvider);
    final notifier = ref.read(addPlaceViewModelProvider.notifier);
    final descriptionController = useTextEditingController(text: state.description);

    return GSTextField(
      label: 'Description',
      placeholder: 'Ajoutez une description...',
      controller: descriptionController,
      maxLines: 4,
      onValueChange: (value) {
        notifier.updateState(state.copyWith(description: value));
      },
    );
  }
}

class _PhotoSectionWrapper extends ConsumerWidget {
  const _PhotoSectionWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addPlaceViewModelProvider);
    final notifier = ref.read(addPlaceViewModelProvider.notifier);

    return _PhotoSection(
      imageUrl: state.imageUrl,
      onPickImage: notifier.pickImage,
      onRemoveImage: () {
        notifier.updateState(state.copyWith(imageUrl: null));
      },
    );
  }
}

class _PhotoSection extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onPickImage;
  final VoidCallback onRemoveImage;

  const _PhotoSection({
    required this.imageUrl,
    required this.onPickImage,
    required this.onRemoveImage,
  });

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
                color: imageUrl != null ? GSColors.primary500 : GSColors.neutral300,
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
  final String imageUrl;
  final VoidCallback onRemove;

  const _ImageWithActions({
    required this.imageUrl,
    required this.onRemove,
  });

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
  final VoidCallback onTap;
  const _DeletePhotoButton({required this.onTap});

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
          child: const Icon(Icons.camera_alt, color: GSColors.neutral600, size: 32),
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
  final String imageUrl;
  const _ImagePreview({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.error_outline)),
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