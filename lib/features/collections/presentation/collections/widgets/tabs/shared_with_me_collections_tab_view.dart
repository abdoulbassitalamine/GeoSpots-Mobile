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
