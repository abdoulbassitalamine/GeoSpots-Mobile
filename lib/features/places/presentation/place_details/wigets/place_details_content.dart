import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../../domain/entity/place_entity.dart';

class PlaceDetailsContent extends StatelessWidget {
  final PlaceEntity place;

  const PlaceDetailsContent({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GSColors.neutral000,
      padding: const EdgeInsets.all(GSSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PlaceHeader(
            title: place.title,
            city: place.city,
            country: place.country,
          ),
          if (place.tags.isNotEmpty) ...[
            const SizedBox(height: GSSpacing.xl),
            _PlaceTags(tags: place.tags),
          ],
          const SizedBox(height: GSSpacing.xl3),
          _PlaceDescription(description: place.description),
          if (place.date.isNotEmpty) ...[
            const SizedBox(height: GSSpacing.xl),
            _PlaceMetaInfo(date: place.date),
          ],
        ],
      ),
    );
  }
}

class _PlaceHeader extends StatelessWidget {
  final String title;
  final String? city;
  final String? country;

  const _PlaceHeader({
    required this.title,
    this.city,
    this.country,
  });

  @override
  Widget build(BuildContext context) {
    final locationText = [city, country].where((e) => e != null).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GSTypography.headingMedium.copyWith(
            color: GSColors.neutral1000,
          ),
        ),
        if (locationText.isNotEmpty) ...[
          const SizedBox(height: GSSpacing.m),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 16,
                color: GSColors.neutral500,
              ),
              const SizedBox(width: GSSpacing.xs),
              Expanded(
                child: Text(
                  locationText,
                  style: GSTypography.bodyDefaultSmall.copyWith(
                    color: GSColors.neutral600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _PlaceTags extends StatelessWidget {
  final List<String> tags;

  const _PlaceTags({required this.tags});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: GSSpacing.s,
      runSpacing: GSSpacing.s,
      children: tags.map((tag) => _TagChip(tag: tag)).toList(),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.l,
        vertical: GSSpacing.s,
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

class _PlaceDescription extends StatelessWidget {
  final String description;

  const _PlaceDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: GSTypography.bodyAccentMedium.copyWith(
            fontSize: GSFontScale.sf05,
          ),
        ),
        const SizedBox(height: GSSpacing.m),
        Text(
          description,
          style: GSTypography.bodyDefaultMedium.copyWith(
            color: GSColors.neutral700,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _PlaceMetaInfo extends StatelessWidget {
  final String date;

  const _PlaceMetaInfo({required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today,
          size: 16,
          color: GSColors.neutral500,
        ),
        const SizedBox(width: GSSpacing.xs),
        Text(
          date,
          style: GSTypography.bodyDefaultSmall.copyWith(
            color: GSColors.neutral600,
          ),
        ),
      ],
    );
  }
}