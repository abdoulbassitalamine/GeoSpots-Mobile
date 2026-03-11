import 'package:flutter/material.dart';
import '../../../../../../shared/design_system/design_system.dart';

class AddSharedAccessHeader extends StatelessWidget {
  const AddSharedAccessHeader({
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
            top: -44,
            right: -12,
            child: _GlowOrb(
              size: 132,
              color: GSColors.neutral000.withValues(alpha: 0.10),
            ),
          ),
          Positioned(
            bottom: -58,
            left: -16,
            child: _GlowOrb(
              size: 148,
              color: GSColors.primary300.withValues(alpha: 0.18),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                GSSpacing.xs,
                GSSpacing.s,
                GSSpacing.xl,
                GSSpacing.xl3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const GSBackButton(
                        color: GSColors.neutral000,
                      ),
                      const SizedBox(width: GSSpacing.m),
                      Expanded(
                        child: Text(
                          title,
                          style: GSTypography.headingMedium.copyWith(
                            color: GSColors.neutral000,
                            fontSize: GSFontScale.sf08,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: GSSpacing.l),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: GSSpacing.m,
                    ),
                    child: Text(
                      subtitle,
                      style: GSTypography.bodyDefaultMedium.copyWith(
                        color: GSColors.neutral000.withValues(alpha: 0.82),
                      ),
                    ),
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

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

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
