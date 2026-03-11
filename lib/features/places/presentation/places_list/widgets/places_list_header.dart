import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';

class PlacesListHeader extends StatelessWidget {
  const PlacesListHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: GSColorTokens.primaryGradientVertical,
      ),
      child: Stack(
        children: [
          Positioned(
            top: -48,
            right: -20,
            child: _Orb(
              size: 144,
              color: GSColors.neutral000.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: -64,
            left: -20,
            child: _Orb(
              size: 164,
              color: GSColors.primary300.withValues(alpha: 0.16),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                GSSpacing.xl,
                GSSpacing.xl,
                GSSpacing.xl,
                GSSpacing.xl3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: GSColors.neutral000.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(GSRadius.full),
                          border: Border.all(
                            color: GSColors.neutral000.withValues(alpha: 0.16),
                          ),
                        ),
                        child: GSBackButton(
                          color: GSColors.neutral000,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: GSSpacing.l),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Places',
                              style: GSTypography.labelAccent.copyWith(
                                color: GSColors.neutral000.withValues(
                                  alpha: 0.88,
                                ),
                              ),
                            ),
                            const SizedBox(height: GSSpacing.s),
                            Text(
                              title,
                              style: GSTypography.headingMedium.copyWith(
                                color: GSColors.neutral000,
                                fontSize: GSFontScale.sf08,
                              ),
                            ),
                            const SizedBox(height: GSSpacing.s),
                            Text(
                              'Retrouvez vos lieux importants avec une lecture plus claire et plus rapide.',
                              style: GSTypography.bodyDefaultMedium.copyWith(
                                color: GSColors.neutral000.withValues(
                                  alpha: 0.80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: GSSpacing.xl),
                  GSInfoChip(
                    icon: Icons.place_outlined,
                    label: subtitle,
                    backgroundColor: GSColors.neutral000.withValues(
                      alpha: 0.14,
                    ),
                    borderColor: GSColors.neutral000.withValues(alpha: 0.20),
                    foregroundColor: GSColors.neutral000,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
