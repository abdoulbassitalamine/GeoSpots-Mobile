import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';

import '../../../../../../shared/design_system/design_system.dart';

part 'shared_with_me_collections_tab_view_card.dart';
part 'shared_with_me_collections_tab_view_dialog.dart';

class SharedWithMeCollectionsTabView extends StatelessWidget {
  const SharedWithMeCollectionsTabView({
    super.key,
    required this.collections,
    required this.sharedTokensByCollectionId,
    required this.onRemoveAccess,
    required this.onCollectionTap,
  });

  final List<CollectionEntity> collections;
  final Map<String, SharedAccessTokenEntity> sharedTokensByCollectionId;
  final ValueChanged<String> onRemoveAccess;
  final ValueChanged<CollectionEntity> onCollectionTap;

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) {
      return GSPremiumPanel(
        padding: const EdgeInsets.all(GSSpacing.xl3),
        borderColor: GSColors.neutral150,
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: GSColors.warning100,
                borderRadius: BorderRadius.circular(GSRadius.full),
              ),
              child: const Icon(
                Icons.folder_shared_outlined,
                color: GSColors.warning700,
                size: 32,
              ),
            ),
            const SizedBox(height: GSSpacing.xl),
            Text(
              'Aucune collection partagée',
              style: GSTypography.bodyAccentLarge.copyWith(
                color: GSColors.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GSSpacing.s),
            Text(
              'Ajoutez un accès partagé pour faire apparaître ici les collections reçues.',
              style: GSTypography.bodyDefaultMedium.copyWith(
                color: GSColors.neutral650,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < collections.length; i++)
          Padding(
            padding: EdgeInsets.only(
              bottom: i == collections.length - 1 ? 0 : GSSpacing.l,
            ),
            child: _SharedWithMeCollectionCard(
              collection: collections[i],
              token: sharedTokensByCollectionId[collections[i].id],
              onCollectionTap: onCollectionTap,
              onRemoveAccess: onRemoveAccess,
            ),
          ),
      ],
    );
  }
}
