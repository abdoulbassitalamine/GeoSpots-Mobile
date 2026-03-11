part of 'upsert_place_basic_info_step.dart';

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
    if (gsIsRemoteImageSource(imageUrl)) {
      return GSProtectedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: const Center(child: Icon(Icons.image_outlined)),
        errorBuilder: (_, _, _) =>
            const Center(child: Icon(Icons.error_outline)),
      );
    }

    return Image.file(File(imageUrl), fit: BoxFit.cover);
  }
}
