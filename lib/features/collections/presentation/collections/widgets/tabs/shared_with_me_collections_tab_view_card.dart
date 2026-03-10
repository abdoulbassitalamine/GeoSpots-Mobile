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

    return GSCard(
      onTap: () => onCollectionTap(collection),
      padding: const EdgeInsets.all(GSSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: GSColors.primary600.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(GSRadius.m),
                ),
                child: const Icon(
                  Icons.folder_shared_outlined,
                  color: GSColors.primary600,
                ),
              ),
              const SizedBox(width: GSSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collection.tag,
                      style: GSTypography.bodyAccentMedium.copyWith(
                        color: GSColors.neutral1000,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    Text(
                      '${collection.placesCount} ${collection.placesCount > 1 ? 'lieux' : 'lieu'}',
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral600,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: GSColors.neutral500),
            ],
          ),
          const SizedBox(height: GSSpacing.m),
          Row(
            children: [
              if (rights != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GSSpacing.s,
                    vertical: GSSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: rights.value == 'WRITE'
                        ? GSColors.success100
                        : GSColors.warning100,
                    borderRadius: BorderRadius.circular(GSRadius.full),
                  ),
                  child: Text(
                    'Droits: ${rights.label}',
                    style: GSTypography.captionDefault.copyWith(
                      color: rights.value == 'WRITE'
                          ? GSColors.success700
                          : GSColors.warning700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const Spacer(),
              if (token != null)
                GSIconButton(
                  icon: Icons.remove_circle_outline,
                  tooltip: 'Retirer cet accès',
                  color: GSColors.danger600,
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
