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
    return GSCard(
      padding: const EdgeInsets.all(GSSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.folder_open, color: GSColors.primary600),
              const SizedBox(width: GSSpacing.s),
              Expanded(
                child: Text(
                  '$filtered / $total lieux affichés',
                  style: GSTypography.bodyDefaultMedium.copyWith(
                    color: GSColors.neutral800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.s),
          Wrap(
            spacing: GSSpacing.s,
            runSpacing: GSSpacing.s,
            children: [
              _Badge(
                label: sourceLabel,
                background: GSColors.neutral100,
                foreground: GSColors.neutral700,
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
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: GSSpacing.s,
        vertical: GSSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(GSRadius.full),
      ),
      child: Text(
        label,
        style: GSTypography.captionDefault.copyWith(
          color: foreground,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
