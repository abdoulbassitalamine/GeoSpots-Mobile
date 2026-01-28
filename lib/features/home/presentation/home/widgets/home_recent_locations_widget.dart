import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/design_system.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/utils/extensions/sized_box_extension.dart';
import '../../../domain/entity/place_entity.dart';

class HomeRecentLocationsWidget extends ConsumerWidget {
  const HomeRecentLocationsWidget({super.key, required this.recentPlaces});

  final List<PlaceEntity> recentPlaces;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lieux récents',
              style: context.headingMedium.copyWith(
                fontSize: GSFontScale.sf06,
                fontWeight: FontWeight.bold,
                color: GSColorTokens.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Voir tout',
                style: context.bodyDefaultSmall.copyWith(
                  fontSize: GSFontScale.sf03,
                  fontWeight: FontWeight.w600,
                  color: GSColorTokens.textAccent,
                ),
              ),
            ),
          ],
        ),
        GSSpacing.$200.toInt().toHeight,
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recentPlaces.length,
          itemBuilder: (context, index) {
            final place = recentPlaces[index];
            return Padding(
              padding: EdgeInsets.only(bottom: GSSpacing.$200),
              child: GSLocationCard(
                title: place.title,
                description: place.description,
                tags: place.tags,
                date: place.date,
              ),
            );
          },
        ),
      ],
    );
  }
}
