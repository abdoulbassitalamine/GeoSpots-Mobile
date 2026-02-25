import 'package:flutter/material.dart';
import 'package:geo_spots/features/places/domain/entity/place_entity.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../shared/design_system/design_system.dart';

class MapPlacePreviewModel {
  const MapPlacePreviewModel({
    required this.place,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.icon,
    required this.point,
  });

  final PlaceEntity place;
  final String title;
  final String subtitle;
  final String category;
  final IconData icon;
  final LatLng point;
}

class MapPlacePreviewCard extends StatelessWidget {
  const MapPlacePreviewCard({
    super.key,
    required this.place,
    required this.onDirectionsTap,
    required this.onShareTap,
    this.compact = false,
    this.onClose,
  });

  final MapPlacePreviewModel place;
  final VoidCallback onDirectionsTap;
  final VoidCallback onShareTap;
  final bool compact;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final tags = place.place.tags.isEmpty
        ? const ['Sans tag']
        : place.place.tags;
    final visibleTags = tags.take(compact ? 1 : 2).toList();
    final hiddenTagsCount = tags.length - visibleTags.length;
    final cardPadding = compact ? GSSpacing.l : GSSpacing.xl;
    final leadingSize = compact ? 42.0 : 52.0;

    return GSCard(
      padding: EdgeInsets.all(cardPadding),
      borderRadius: BorderRadius.circular(GSRadius.l),
      border: Border.all(color: GSColors.neutral150),
      shadows: [GSShadows.s()],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: leadingSize,
                height: leadingSize,
                decoration: BoxDecoration(
                  color: GSColors.primary100,
                  borderRadius: BorderRadius.circular(GSRadius.m),
                ),
                child: Icon(
                  place.icon,
                  color: GSColors.primary700,
                  size: compact ? 20 : 24,
                ),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            place.title,
                            style: GSTypography.bodyAccentMedium.copyWith(
                              color: GSColors.neutral1000,
                              fontSize: compact ? GSFontScale.sf04 : GSFontScale.sf05,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (onClose != null)
                          GSIconButton(
                            icon: Icons.close,
                            tooltip: 'Masquer l’aperçu',
                            onPressed: onClose,
                          ),
                      ],
                    ),
                    const SizedBox(height: GSSpacing.s),
                    Text(
                      place.subtitle,
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: GSSpacing.s),
                    Wrap(
                      spacing: GSSpacing.s,
                      runSpacing: GSSpacing.s,
                      children: [
                        for (final tag in visibleTags) _TagPill(tag: tag),
                        if (hiddenTagsCount > 0)
                          _TagPill(tag: '+$hiddenTagsCount'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? GSSpacing.m : GSSpacing.xl),
          Row(
            children: [
              Expanded(
                child: GSFilledButton(
                  onPressed: onDirectionsTap,
                  text: 'Itinéraire',
                  icon: Icons.route,
                  fullWidth: true,
                  padding: EdgeInsets.symmetric(
                    horizontal: GSSpacing.l,
                    vertical: compact ? GSSpacing.m : GSSpacing.l,
                  ),
                ),
              ),
              if (!compact) ...[
                const SizedBox(width: GSSpacing.m),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: GSColors.neutral100,
                    borderRadius: BorderRadius.circular(GSRadius.m),
                  ),
                  child: GSIconButton(
                    icon: Icons.share,
                    tooltip: 'Partager',
                    onPressed: onShareTap,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TagPill extends StatelessWidget {
  const _TagPill({required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.m,
        vertical: GSSpacing.s,
      ),
      decoration: BoxDecoration(
        color: GSColors.neutral100,
        borderRadius: BorderRadius.circular(GSRadius.full),
      ),
      child: Text(
        tag,
        style: GSTypography.captionDefault.copyWith(
          color: GSColors.neutral700,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
