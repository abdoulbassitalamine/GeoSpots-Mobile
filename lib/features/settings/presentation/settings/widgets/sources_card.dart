import 'package:flutter/material.dart';
import '../../../../../shared/design_system/design_system.dart';

class SourcesCard extends StatelessWidget {
  const SourcesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GSCard(
      padding: const EdgeInsets.all(GSSpacing.xl),
      onTap: () {
        // TODO: Navigation vers la gestion des sources
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(GSSpacing.l),
            decoration: BoxDecoration(
              color: GSColors.info100,
              borderRadius: BorderRadius.circular(GSRadius.m),
            ),
            child: const Icon(
              Icons.storage,
              color: GSColors.info600,
              size: 24,
            ),
          ),
          const SizedBox(width: GSSpacing.l),
          Expanded(
            child: Text(
              'Mes sources',
              style: GSTypography.bodyAccentMedium.copyWith(
                fontSize: GSFontScale.sf05,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: GSColors.neutral400,
          ),
        ],
      ),
    );
  }
}