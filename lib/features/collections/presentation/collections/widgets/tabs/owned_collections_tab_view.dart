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
      return Text(
        'Aucune collection.',
        style: GSTypography.bodyDefaultMedium.copyWith(
          color: GSColors.neutral600,
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
