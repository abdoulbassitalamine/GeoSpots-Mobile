import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';

class CollectionDetailsSummary extends StatelessWidget {
  const CollectionDetailsSummary({
    super.key,
    required this.total,
    required this.filtered,
    required this.sourceLabel,
    this.rightsLabel,
  });

  final int total;
  final int filtered;
  final String sourceLabel;
  final String? rightsLabel;

  @override
  Widget build(BuildContext context) {
    return GSPremiumPanel(
      padding: const EdgeInsets.all(GSSpacing.xl),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [GSColors.primary700, GSColors.primary600, GSColors.primary500],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aperçu de la collection',
            style: GSTypography.labelAccent.copyWith(
              color: GSColors.neutral000.withValues(alpha: 0.82),
            ),
          ),
          const SizedBox(height: GSSpacing.m),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: GSColors.neutral000.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(GSRadius.l),
                ),
                child: const Icon(
                  Icons.folder_open_rounded,
                  color: GSColors.neutral000,
                ),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Text(
                  '$filtered / $total lieux affichés',
                  style: GSTypography.headingSmall.copyWith(
                    color: GSColors.neutral000,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.m),
          Text(
            'Naviguez plus vite dans les lieux de cette collection grâce à une vue claire, filtrée et lisible.',
            style: GSTypography.bodyDefaultSmall.copyWith(
              color: GSColors.neutral000.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: GSSpacing.xl),
          Wrap(
            spacing: GSSpacing.s,
            runSpacing: GSSpacing.s,
            children: [
              _Badge(
                label: sourceLabel,
                background: GSColors.neutral000.withValues(alpha: 0.14),
                foreground: GSColors.neutral000,
              ),
              if (rightsLabel != null)
                _Badge(
                  label: 'Droits: $rightsLabel',
                  background: rightsLabel == 'Écriture'
                      ? GSColors.success100
                      : GSColors.warning100,
                  foreground: rightsLabel == 'Écriture'
                      ? GSColors.success700
                      : GSColors.warning700,
                ),
              _Badge(
                label: filtered == total ? 'Vue complète' : 'Résultats filtrés',
                background: GSColors.neutral000.withValues(alpha: 0.14),
                foreground: GSColors.neutral000,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return GSInfoChip(
      label: label,
      backgroundColor: background,
      foregroundColor: foreground,
      borderColor: background.withValues(alpha: 0.7),
    );
  }
}
