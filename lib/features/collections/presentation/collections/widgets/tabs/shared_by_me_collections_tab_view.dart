import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';

import '../../../../../../shared/design_system/design_system.dart';

part 'shared_by_me_collections_tab_view_card.dart';
part 'shared_by_me_collections_tab_view_pills.dart';

class SharedByMeCollectionsTabView extends StatelessWidget {
  const SharedByMeCollectionsTabView({
    super.key,
    required this.collections,
    required this.tokensByCollection,
    required this.onCollectionTap,
    required this.onRevokeTokenById,
  });

  final List<CollectionEntity> collections;
  final Map<String, List<SharedAccessTokenEntity>> tokensByCollection;
  final ValueChanged<CollectionEntity> onCollectionTap;
  final ValueChanged<String> onRevokeTokenById;

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
                color: GSColors.info100,
                borderRadius: BorderRadius.circular(GSRadius.full),
              ),
              child: const Icon(
                Icons.key_outlined,
                color: GSColors.info700,
                size: 32,
              ),
            ),
            const SizedBox(height: GSSpacing.xl),
            Text(
              'Aucun partage actif',
              style: GSTypography.bodyAccentLarge.copyWith(
                color: GSColors.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GSSpacing.s),
            Text(
              'Partagez une collection pour gérer ici tous vos accès et leurs droits.',
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
            child: _SharedByMeCollectionCard(
              collection: collections[i],
              tokens: tokensByCollection[collections[i].id] ?? const [],
              onOpenCollection: () => onCollectionTap(collections[i]),
              onRevokeTokenById: onRevokeTokenById,
            ),
          ),
      ],
    );
  }
}
