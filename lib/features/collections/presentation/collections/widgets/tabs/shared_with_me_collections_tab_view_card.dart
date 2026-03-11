part of 'shared_with_me_collections_tab_view.dart';

class _SharedWithMeCollectionCard extends StatelessWidget {
  const _SharedWithMeCollectionCard({
    required this.collection,
    required this.token,
    required this.onCollectionTap,
    required this.onRemoveAccess,
  });

  final CollectionEntity collection;
  final SharedAccessTokenEntity? token;
  final ValueChanged<CollectionEntity> onCollectionTap;
  final ValueChanged<String> onRemoveAccess;

  @override
  Widget build(BuildContext context) {
    final rights = token?.rights;

    return GSPremiumPanel(
      onTap: () => onCollectionTap(collection),
      padding: const EdgeInsets.all(GSSpacing.xl),
      borderColor: GSColors.neutral150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [GSColors.warning100, GSColors.primary100],
                  ),
                  borderRadius: BorderRadius.circular(GSRadius.l),
                ),
                child: const Icon(
                  Icons.folder_shared_outlined,
                  color: GSColors.primary700,
                ),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GSInfoChip(
                      icon: Icons.link,
                      label: 'Collection reçue',
                      backgroundColor: GSColors.neutral100,
                      borderColor: GSColors.neutral150,
                    ),
                    const SizedBox(height: GSSpacing.m),
                    Text(
                      collection.tag,
                      style: GSTypography.bodyAccentLarge.copyWith(
                        color: GSColors.neutral1000,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.s),
                    Wrap(
                      spacing: GSSpacing.s,
                      runSpacing: GSSpacing.s,
                      children: [
                        GSInfoChip(
                          icon: Icons.place_outlined,
                          label:
                              '${collection.placesCount} ${collection.placesCount > 1 ? 'lieux' : 'lieu'}',
                          backgroundColor: GSColors.primary50,
                          borderColor: GSColors.primary100,
                          foregroundColor: GSColors.primary700,
                        ),
                        if (rights != null)
                          GSInfoChip(
                            icon: rights.value == 'WRITE'
                                ? Icons.edit_outlined
                                : Icons.remove_red_eye_outlined,
                            label: rights.label,
                            backgroundColor: rights.value == 'WRITE'
                                ? GSColors.success100
                                : GSColors.warning100,
                            borderColor: rights.value == 'WRITE'
                                ? GSColors.success200
                                : GSColors.warning200,
                            foregroundColor: rights.value == 'WRITE'
                                ? GSColors.success700
                                : GSColors.warning700,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: GSColors.neutral500,
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.xl),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Ouvrir et parcourir la collection',
                  style: GSTypography.bodyDefaultSmall.copyWith(
                    color: GSColors.neutral650,
                  ),
                ),
              ),
              if (token != null)
                _RemoveAccessButton(
                  onPressed: () => _confirmRemoveAccess(
                    context,
                    collectionName: collection.tag,
                    token: token!.token,
                    onRemoveAccess: onRemoveAccess,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RemoveAccessButton extends StatelessWidget {
  const _RemoveAccessButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GSColors.danger100,
        borderRadius: BorderRadius.circular(GSRadius.full),
      ),
      child: GSIconButton(
        icon: Icons.remove_circle_outline,
        tooltip: 'Retirer cet accès',
        color: GSColors.danger600,
        onPressed: onPressed,
        size: 20,
      ),
    );
  }
}
