import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';

class TrackingToggle extends StatelessWidget {
  final bool isEnabled;
  final Function(bool) onChanged;

  const TrackingToggle({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(GSSpacing.xl),
      decoration: BoxDecoration(
        color: GSColors.neutral000,
        borderRadius: BorderRadius.circular(GSRadius.m),
        border: Border.all(
          color: isEnabled ? GSColors.primary600 : GSColors.neutral300,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(GSSpacing.l),
            decoration: BoxDecoration(
              color: isEnabled
                  ? GSColors.primary600.withValues(alpha: 0.1)
                  : GSColors.neutral100,
              borderRadius: BorderRadius.circular(GSRadius.m),
            ),
            child: Icon(
              Icons.location_on,
              color: isEnabled ? GSColors.primary600 : GSColors.neutral500,
              size: 24,
            ),
          ),
          const SizedBox(width: GSSpacing.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Partage de position',
                  style: GSTypography.bodyAccentMedium.copyWith(
                    fontSize: GSFontScale.sf04,
                  ),
                ),
                const SizedBox(height: GSSpacing.xs),
                Text(
                  isEnabled
                      ? 'Position partagée en temps réel'
                      : 'Partager votre position automatiquement',
                  style: GSTypography.bodyDefaultSmall.copyWith(
                    color: GSColors.neutral600,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeThumbColor: GSColors.primary600,
          ),
        ],
      ),
    );
  }
}
