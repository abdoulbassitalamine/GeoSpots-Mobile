import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../core/utils/extensions/sized_box_extension.dart';
import '../../../../../shared/design_system/design_system.dart';
import 'home_stats_widget.dart';

class HomeHeaderWidget extends ConsumerWidget {
  const HomeHeaderWidget({
    super.key,
    required this.username,
    required this.placesCount,
    required this.collectionsCount,
  });

  final String username;
  final int placesCount;
  final int collectionsCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        gradient: GSColorTokens.primaryGradientVertical,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: GSSpacing.$300,
        vertical: GSSpacing.$250,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bonjour,',
                  style: context.headingMedium.copyWith(
                    fontSize: GSFontScale.sf04,
                    color: GSColors.neutral000.withValues(alpha: .8),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(GSRadius.m),
                  ),
                  child: Icon(
                    Icons.settings,
                    color: GSColors.neutral000,
                    size: 24,
                  ),
                ),
              ],
            ),

            Text(
              username,
              style: context.headingMedium.copyWith(
                fontSize: GSFontScale.sf07,
                color: GSColors.neutral000,
                fontWeight: FontWeight.bold,
              ),
            ),

            GSSpacing.$200.toInt().toHeight,

            HomeStatsWidget(
              placesCount: placesCount,
              collectionsCount: collectionsCount,
            ),
          ],
        ),
      ),
    );
  }
}
