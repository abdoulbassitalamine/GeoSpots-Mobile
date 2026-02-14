import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/enums/share_access_right.dart';

import '../../../../../../shared/design_system/design_system.dart';

class SharedWithMeCollectionsTabView extends StatelessWidget {
  const SharedWithMeCollectionsTabView({
    super.key,
    required this.collections,
    required this.onRemoveAccess,
    required this.onCollectionTap,
  });

  final List<CollectionEntity> collections;
  final ValueChanged<String> onRemoveAccess;
  final ValueChanged<CollectionEntity> onCollectionTap;

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return Text(
        'Aucune collection partagée.',
        style: GSTypography.bodyDefaultMedium.copyWith(
          color: GSColors.neutral600,
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < collections.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == collections.length - 1 ? 0 : GSSpacing.l),
            child: GSCard(
              onTap: () => onCollectionTap(collections[i]),
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
                              collections[i].tag,
                              style: GSTypography.bodyAccentMedium.copyWith(
                                color: GSColors.neutral1000,
                              ),
                            ),
                            const SizedBox(height: GSSpacing.xs),
                            Text(
                              '${collections[i].placesCount} ${collections[i].placesCount > 1 ? 'lieux' : 'lieu'}',
                              style: GSTypography.bodyDefaultSmall.copyWith(
                                color: GSColors.neutral600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: GSColors.neutral500,
                      ),
                    ],
                  ),
                  const SizedBox(height: GSSpacing.m),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: GSSpacing.s,
                          vertical: GSSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: collections[i].rights == ShareAccessRight.write
                              ? GSColors.success100
                              : GSColors.warning100,
                          borderRadius: BorderRadius.circular(GSRadius.full),
                        ),
                        child: Text(
                          'Droits: ${collections[i].rights.label}',
                          style: GSTypography.captionDefault.copyWith(
                            color: collections[i].rights == ShareAccessRight.write
                                ? GSColors.success700
                                : GSColors.warning700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (collections[i].sharedToken != null)
                        GSIconButton(
                          icon: Icons.remove_circle_outline,
                          tooltip: 'Retirer cet accès',
                          color: GSColors.danger600,
                          onPressed: () => _confirmRemoveAccess(
                            context,
                            collections[i].tag,
                            collections[i].sharedToken!,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _confirmRemoveAccess(
    BuildContext context,
    String collectionName,
    String token,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GSRadius.l),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            GSSpacing.xl,
            GSSpacing.xl,
            GSSpacing.xl,
            0,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            GSSpacing.xl,
            GSSpacing.m,
            GSSpacing.xl,
            GSSpacing.xl,
          ),
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: GSColors.danger100,
                  borderRadius: BorderRadius.circular(GSRadius.full),
                ),
                child: const Icon(
                  Icons.remove_circle_outline,
                  color: GSColors.danger600,
                  size: 20,
                ),
              ),
              const SizedBox(width: GSSpacing.s),
              Expanded(
                child: Text(
                  'Retirer cet accès ?',
                  style: GSTypography.headingSmall.copyWith(
                    color: GSColors.neutral1000,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Collection: $collectionName',
                style: GSTypography.bodyAccentMedium.copyWith(
                  color: GSColors.neutral900,
                ),
              ),
              const SizedBox(height: GSSpacing.s),
              Text(
                'Vous ne verrez plus cette collection dans "Partagées avec moi".',
                style: GSTypography.bodyDefaultSmall.copyWith(
                  color: GSColors.neutral700,
                ),
              ),
              const SizedBox(height: GSSpacing.m),
              Container(
                padding: const EdgeInsets.all(GSSpacing.m),
                decoration: BoxDecoration(
                  color: GSColors.warning100,
                  borderRadius: BorderRadius.circular(GSRadius.m),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: GSColors.warning700,
                    ),
                    const SizedBox(width: GSSpacing.s),
                    Expanded(
                      child: Text(
                        'Cette action retire uniquement ton accès local.',
                        style: GSTypography.captionDefault.copyWith(
                          color: GSColors.warning700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: GSSpacing.l),
              Row(
                children: [
                  Expanded(
                    child: GSOutlinedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      text: 'Annuler',
                    ),
                  ),
                  const SizedBox(width: GSSpacing.s),
                  Expanded(
                    child: GSFilledButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      text: 'Retirer',
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: const [SizedBox.shrink()],
          actionsPadding: EdgeInsets.zero,
          buttonPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: GSSpacing.xl,
            vertical: GSSpacing.l,
          ),
        );
      },
    );

    if (confirmed == true) {
      onRemoveAccess(token);
    }
  }
}
