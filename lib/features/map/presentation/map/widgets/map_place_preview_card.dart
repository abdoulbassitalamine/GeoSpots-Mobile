import 'dart:ui';

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
    final leadingSize = compact ? 48.0 : 58.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(GSRadius.l),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: EdgeInsets.all(cardPadding),
          decoration: BoxDecoration(
            color: GSColors.neutral000.withValues(alpha: 0.86),
            borderRadius: BorderRadius.circular(GSRadius.l),
            border: Border.all(
              color: GSColors.neutral000.withValues(alpha: 0.74),
            ),
            boxShadow: [
              GSShadows.l(color: GSColors.neutral1000.withValues(alpha: 0.14)),
            ],
          ),
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
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [GSColors.primary100, GSColors.primary600],
                      ),
                      borderRadius: BorderRadius.circular(GSRadius.l),
                    ),
                    child: Icon(
                      place.icon,
                      color: GSColors.neutral000,
                      size: compact ? 22 : 26,
                    ),
                  ),
                  const SizedBox(width: GSSpacing.l),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: GSSpacing.s,
                          runSpacing: GSSpacing.s,
                          children: [
                            GSInfoChip(
                              icon: Icons.sell_outlined,
                              label: place.category,
                              backgroundColor: GSColors.primary50,
                              borderColor: GSColors.primary100,
                              foregroundColor: GSColors.primary700,
                            ),
                            if (place.place.isShared)
                              const GSInfoChip(
                                icon: Icons.share_outlined,
                                label: 'Partagé',
                                backgroundColor: GSColors.warning100,
                                borderColor: GSColors.warning200,
                                foregroundColor: GSColors.warning700,
                              ),
                          ],
                        ),
                        const SizedBox(height: GSSpacing.m),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                place.title,
                                style: GSTypography.bodyAccentLarge.copyWith(
                                  color: GSColors.neutral1000,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (onClose != null)
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: GSColors.neutral100,
                                  borderRadius: BorderRadius.circular(
                                    GSRadius.full,
                                  ),
                                ),
                                child: GSIconButton(
                                  icon: Icons.close,
                                  tooltip: 'Masquer l’aperçu',
                                  onPressed: onClose,
                                  size: 18,
                                ),
                              ),
                          ],
                        ),
                        if (place.subtitle.isNotEmpty) ...[
                          const SizedBox(height: GSSpacing.s),
                          Text(
                            place.subtitle,
                            style: GSTypography.bodyDefaultSmall.copyWith(
                              color: GSColors.neutral650,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GSSpacing.xl),
              Wrap(
                spacing: GSSpacing.s,
                runSpacing: GSSpacing.s,
                children: [
                  for (final tag in visibleTags)
                    GSInfoChip(
                      label: tag,
                      backgroundColor: GSColors.neutral100,
                      borderColor: GSColors.neutral150,
                    ),
                  if (hiddenTagsCount > 0)
                    GSInfoChip(
                      label: '+$hiddenTagsCount',
                      backgroundColor: GSColors.neutral100,
                      borderColor: GSColors.neutral150,
                    ),
                ],
              ),
              SizedBox(height: compact ? GSSpacing.l : GSSpacing.xl),
              Row(
                children: [
                  Expanded(
                    child: GSFilledButton(
                      onPressed: onDirectionsTap,
                      text: 'Itinéraire',
                      icon: Icons.route_outlined,
                      fullWidth: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: GSSpacing.l,
                        vertical: compact ? GSSpacing.m : GSSpacing.l,
                      ),
                    ),
                  ),
                  const SizedBox(width: GSSpacing.m),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: GSColors.neutral100,
                      borderRadius: BorderRadius.circular(GSRadius.l),
                    ),
                    child: GSIconButton(
                      icon: Icons.share_outlined,
                      tooltip: 'Partager',
                      onPressed: onShareTap,
                      color: GSColors.neutral800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
