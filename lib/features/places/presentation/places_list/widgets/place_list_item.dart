import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../domain/entity/place_entity.dart';

class PlaceListItem extends StatelessWidget {
  const PlaceListItem({super.key, required this.place, required this.onTap});
  final PlaceEntity place;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GSCard(
      onTap: onTap,
      padding: const EdgeInsets.all(GSSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (place.imageUrl != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(GSRadius.s),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: GSColors.neutral200,
                    child: const Icon(Icons.image, color: GSColors.neutral400),
                  ),
                ),
                const SizedBox(width: GSSpacing.l),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.title,
                      style: GSTypography.bodyAccentMedium.copyWith(
                        fontSize: GSFontScale.sf05,
                        color: GSColors.neutral1000,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    if (place.isShared) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: GSSpacing.s,
                          vertical: GSSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: GSColors.warning100,
                          borderRadius: BorderRadius.circular(GSRadius.full),
                        ),
                        child: Text(
                          'Partagé',
                          style: GSTypography.captionDefault.copyWith(
                            color: GSColors.warning700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: GSSpacing.xs),
                    ],
                    if (place.city != null || place.country != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: GSColors.neutral500,
                          ),
                          const SizedBox(width: GSSpacing.xs),
                          Expanded(
                            child: Text(
                              [
                                place.city,
                                place.country,
                              ].where((e) => e != null).join(', '),
                              style: GSTypography.bodyDefaultSmall.copyWith(
                                color: GSColors.neutral600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.l),
          Text(
            place.description,
            style: GSTypography.bodyDefaultSmall.copyWith(
              color: GSColors.neutral700,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (place.tags.isNotEmpty) ...[
            const SizedBox(height: GSSpacing.l),
            Wrap(
              spacing: GSSpacing.s,
              runSpacing: GSSpacing.s,
              children: place.tags.map(_buildTag).toList(),
            ),
          ],
          const SizedBox(height: GSSpacing.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                place.date,
                style: GSTypography.captionDefault.copyWith(
                  color: GSColors.neutral500,
                ),
              ),
              Row(
                children: [
                  GSIconButton(
                    icon: Icons.directions,
                    onPressed: () {
                      // TODO(dev): Open in maps.
                    },
                    size: 20,
                  ),
                  const SizedBox(width: GSSpacing.s),
                  GSIconButton(
                    icon: Icons.ios_share,
                    onPressed: () {
                      // TODO(dev): Share place.
                    },
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.m,
        vertical: GSSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: GSColors.primary600.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(GSRadius.full),
        border: Border.all(
          color: GSColors.primary600.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        tag,
        style: GSTypography.captionDefault.copyWith(
          color: GSColors.primary600,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
