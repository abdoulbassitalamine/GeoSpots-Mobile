import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/utils/extensions/sized_box_extension.dart';
import '../../../../../shared/design_system/design_system.dart';

class HomeStatsWidget extends ConsumerWidget {
  const HomeStatsWidget({
    super.key,
    required this.placesCount,
    required this.collectionsCount,
  });

  final int placesCount;
  final int collectionsCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: GSSpacing.$250),
      child: Container(
        decoration: BoxDecoration(
          color: GSColors.neutral000.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(GSRadius.l),
        ),
        padding: EdgeInsets.all(GSSpacing.$200),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    icon: Icons.location_on,
                    value: placesCount,
                    label: 'Lieux',
                    color: GSColors.neutral000,
                  ),
                ),
                Container(width: 1, height: 50, color: GSColors.neutral200),
                Expanded(
                  child: _StatItem(
                    icon: Icons.folder,
                    value: collectionsCount,
                    label: 'Collections',
                    color: GSColors.neutral000,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        GSSpacing.$100.toInt().toHeight,
        Text(
          value.toString(),
          style: context.headingMedium.copyWith(
            fontSize: GSFontScale.sf08,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        GSSpacing.$50.toInt().toHeight,
        Text(
          label,
          style: context.bodyDefaultSmall.copyWith(
            fontSize: GSFontScale.sf03,
            color: color,
          ),
        ),
      ],
    );
  }
}
