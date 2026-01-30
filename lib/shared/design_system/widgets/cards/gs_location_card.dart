import 'package:flutter/material.dart';
import 'package:geo_spots/shared/design_system/theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/typography.dart';
import '../../tokens/color_tokens.dart';

class GSLocationCard extends StatelessWidget {
  const GSLocationCard({
    super.key,
    required this.title,
    required this.description,
    required this.tags,
    required this.date,
    this.onTap,
  });

  final String title;
  final String description;
  final List<String> tags;
  final String date;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(GSSpacing.xl),
        decoration: BoxDecoration(color: GSColorTokens.backgroundSecondary),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: GSColorTokens.primaryGradientHorizontal,
                    borderRadius: BorderRadius.circular(GSRadius.s),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: GSColors.neutral000,
                    size: 28,
                  ),
                ),
                const SizedBox(width: GSSpacing.xl),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GSTypography.bodyDefaultMedium.copyWith(
                          fontSize: GSFontScale.sf04,
                          fontWeight: FontWeight.bold,
                          color: GSColorTokens.textPrimary,
                        ),
                      ),
                      const SizedBox(height: GSSpacing.s),
                      Text(
                        description,
                        style: GSTypography.bodyDefaultSmall.copyWith(
                          fontSize: GSFontScale.sf03,
                          color: GSColorTokens.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: GSSpacing.l),
            Wrap(
              spacing: GSSpacing.m,
              children: tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GSSpacing.l,
                    vertical: GSSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: GSColorTokens.backgroundAccentLight,
                    borderRadius: BorderRadius.circular(GSRadius.full),
                  ),
                  child: Text(
                    tag,
                    style: GSTypography.bodyDefaultSmall.copyWith(
                      fontSize: GSFontScale.sf02,
                      fontWeight: FontWeight.w600,
                      color: GSColorTokens.textSecondary,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: GSSpacing.m),
            Text(
              date,
              style: GSTypography.bodyDefaultSmall.copyWith(
                fontSize: GSFontScale.sf02,
                color: GSColorTokens.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
