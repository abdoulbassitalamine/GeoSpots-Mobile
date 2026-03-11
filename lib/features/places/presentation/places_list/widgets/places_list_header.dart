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
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            GSSpacing.xl,
            GSSpacing.xl,
            GSSpacing.xl,
            GSSpacing.xl3,
          ),
          child: Row(
            children: [
              GSBackButton(
                color: GSColors.neutral000,
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GSTypography.headingMedium.copyWith(
                        color: GSColors.neutral000,
                        fontSize: GSFontScale.sf07,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    Text(
                      subtitle,
                      style: GSTypography.bodyDefaultMedium.copyWith(
                        color: GSColors.neutral000.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
