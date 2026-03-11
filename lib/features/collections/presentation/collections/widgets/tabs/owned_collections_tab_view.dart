import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/collection_card.dart';

import '../../../../../../shared/design_system/design_system.dart';

class OwnedCollectionsTabView extends StatelessWidget {
  const OwnedCollectionsTabView({
    super.key,
    required this.collections,
    required this.onCollectionTap,
  });

  final List<CollectionEntity> collections;
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
                color: GSColors.primary100,
                borderRadius: BorderRadius.circular(GSRadius.full),
              ),
              child: const Icon(
                Icons.folder_open_outlined,
                color: GSColors.primary700,
                size: 32,
              ),
            ),
            const SizedBox(height: GSSpacing.xl),
            Text(
              'Aucune collection pour le moment',
              style: GSTypography.bodyAccentLarge.copyWith(
                color: GSColors.neutral900,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: GSSpacing.s),
            Text(
              'Créez vos premiers ensembles de lieux pour retrouver plus vite ce qui compte.',
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
            child: CollectionCard(
              collection: collections[i],
              onTap: () => onCollectionTap(collections[i]),
            ),
          ),
      ],
    );
  }
}
