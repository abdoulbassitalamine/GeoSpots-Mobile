part of 'upsert_place_location_step.dart';

class _TagsSection extends HookWidget {
  const _TagsSection({required this.tags, required this.onTagsChanged});

  final List<String> tags;
  final ValueChanged<List<String>> onTagsChanged;

  @override
  Widget build(BuildContext context) {
    final tagController = useTextEditingController();

    void onAddTag() {
      final v = tagController.text.trim();
      if (v.isEmpty) return;
      onTagsChanged([...tags, v]);
      tagController.clear();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Étiquettes (tags)', style: GSTypography.labelDefault),
        const SizedBox(height: GSSpacing.m),
        if (tags.isNotEmpty) ...[
          Wrap(
            spacing: GSSpacing.s,
            runSpacing: GSSpacing.s,
            children: tags
                .map(
                  (tag) => _TagChip(
                    tag: tag,
                    onRemove: () =>
                        onTagsChanged(tags.where((t) => t != tag).toList()),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: GSSpacing.m),
        ],
        Row(
          children: [
            Expanded(
              child: GSTextField(
                controller: tagController,
                placeholder: 'Ajouter une étiquette...',
                onSubmitted: (_) => onAddTag(),
              ),
            ),
            const SizedBox(width: GSSpacing.m),
            GSIconButton(icon: Icons.add, onPressed: onAddTag),
          ],
        ),
        const SizedBox(height: GSSpacing.m),
        const _TagsInfoRow(),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.tag, required this.onRemove});

  final String tag;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.l,
        vertical: GSSpacing.s,
      ),
      decoration: BoxDecoration(
        color: GSColors.primary100,
        borderRadius: BorderRadius.circular(GSRadius.full),
        border: Border.all(color: GSColors.primary600),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: GSTypography.bodyDefaultSmall.copyWith(
              color: GSColors.primary600,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: GSSpacing.xs),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: GSColors.primary600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagsInfoRow extends StatelessWidget {
  const _TagsInfoRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info_outline, size: 16, color: GSColors.neutral500),
        const SizedBox(width: GSSpacing.xs),
        Expanded(
          child: Text(
            'Les étiquettes créent automatiquement des collections',
            style: GSTypography.captionDefault.copyWith(
              color: GSColors.neutral500,
            ),
          ),
        ),
      ],
    );
  }
}
