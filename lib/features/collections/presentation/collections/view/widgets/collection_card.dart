import 'package:flutter/material.dart';

import '../../../../../../shared/design_system/design_system.dart';
import '../../../../domain/entity/collection_entity.dart';

class CollectionCard extends StatelessWidget {
  final CollectionEntity collection;
  final VoidCallback? onTap;

  const CollectionCard({
    super.key,
    required this.collection,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isAllCollection = collection.tag == 'all';

    return GSCard(
      onTap: isAllCollection ? onTap : null,
      padding: const EdgeInsets.all(GSSpacing.xl),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: GSColors.primary600.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(GSRadius.m),
            ),
            child: Icon(
              isAllCollection ? Icons.public : Icons.label,
              color: GSColors.primary600,
              size: 28,
            ),
          ),
          const SizedBox(width: GSSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAllCollection ? 'Tous les lieux' : collection.tag,
                  style: GSTypography.bodyAccentMedium.copyWith(
                    color: GSColors.neutral1000,
                    fontSize: GSFontScale.sf05,
                  ),
                ),
                const SizedBox(height: GSSpacing.xs),
                Text(
                  isAllCollection
                      ? '${collection.placesCount} lieux enregistrés'
                      : '${collection.placesCount} ${collection.placesCount > 1 ? 'lieux' : 'lieu'}',
                  style: GSTypography.bodyDefaultSmall.copyWith(
                    color: GSColors.neutral600,
                  ),
                ),
              ],
            ),
          ),
          if (!isAllCollection)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GSIconButton(
                  icon: Icons.share,
                  onPressed: () {},
                  size: 24,
                ),
                const SizedBox(width: GSSpacing.s),
                GSIconButton(
                  icon: Icons.download,
                  onPressed: () {},
                  size: 24,
                ),
              ],
            )
          else
            const Icon(Icons.chevron_right, color: GSColors.neutral400),
        ],
      ),
    );
  }
}
