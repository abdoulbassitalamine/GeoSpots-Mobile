import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../../domain/entity/place_entity.dart';

class PlaceDetailsContent extends StatelessWidget {
  const PlaceDetailsContent({super.key, required this.place});

  final PlaceEntity place;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GSColors.neutral050,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(
        GSSpacing.xl,
        GSSpacing.xl3,
        GSSpacing.xl,
        0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: GSSpacing.s,
            runSpacing: GSSpacing.s,
            children: [
              if (place.fullLocation.isNotEmpty)
                GSInfoChip(
                  icon: Icons.location_on_outlined,
                  label: place.fullLocation,
                  backgroundColor: GSColors.neutral000,
                  borderColor: GSColors.neutral150,
                ),
              if (place.hasCoordinates)
                GSInfoChip(
                  icon: Icons.explore_outlined,
                  label:
                      '${place.latitude!.toStringAsFixed(4)}, ${place.longitude!.toStringAsFixed(4)}',
                  backgroundColor: GSColors.neutral000,
                  borderColor: GSColors.neutral150,
                ),
            ],
          ),
          const SizedBox(height: GSSpacing.xl),
          if (place.description.isNotEmpty)
            _SectionCard(
              title: 'Description',
              icon: Icons.notes_rounded,
              child: Text(
                place.description,
                style: GSTypography.bodyDefaultMedium.copyWith(
                  color: GSColors.neutral700,
                  height: 1.7,
                ),
              ),
            ),
          if (place.tags.isNotEmpty) ...[
            const SizedBox(height: GSSpacing.xl),
            _SectionCard(
              title: 'Tags',
              icon: Icons.sell_outlined,
              child: Wrap(
                spacing: GSSpacing.s,
                runSpacing: GSSpacing.s,
                children: place.tags
                    .map(
                      (tag) => GSInfoChip(
                        label: tag,
                        backgroundColor: GSColors.primary50,
                        borderColor: GSColors.primary100,
                        foregroundColor: GSColors.primary700,
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          if (place.fullLocation.isNotEmpty || place.date.isNotEmpty) ...[
            const SizedBox(height: GSSpacing.xl),
            _SectionCard(
              title: 'Informations',
              icon: Icons.info_outline,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (place.fullLocation.isNotEmpty)
                    _MetaLine(
                      icon: Icons.location_on_outlined,
                      label: 'Localisation',
                      value: place.fullLocation,
                    ),
                  if (place.date.isNotEmpty) ...[
                    if (place.fullLocation.isNotEmpty)
                      const SizedBox(height: GSSpacing.l),
                    _MetaLine(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: place.date,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GSPremiumPanel(
      padding: const EdgeInsets.all(GSSpacing.xl),
      borderColor: GSColors.neutral150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: GSColors.primary50,
                  borderRadius: BorderRadius.circular(GSRadius.l),
                ),
                child: Icon(icon, color: GSColors.primary700, size: 20),
              ),
              const SizedBox(width: GSSpacing.m),
              Text(
                title,
                style: GSTypography.bodyAccentLarge.copyWith(
                  color: GSColors.neutral900,
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.xl),
          child,
        ],
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: GSColors.neutral500, size: 18),
        const SizedBox(width: GSSpacing.s),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GSTypography.labelDefault.copyWith(
                  color: GSColors.neutral600,
                ),
              ),
              const SizedBox(height: GSSpacing.xs),
              Text(
                value,
                style: GSTypography.bodyDefaultMedium.copyWith(
                  color: GSColors.neutral800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
