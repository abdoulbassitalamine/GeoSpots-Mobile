import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/enums/export_format.dart';
import '../../../../../../shared/design_system/design_system.dart';

class ExportDialog extends StatelessWidget {
  const ExportDialog({
    super.key,
    required this.collection,
    required this.onExport,
  });

  final CollectionEntity collection;
  final Function(ExportFormat) onExport;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Exporter la collection', style: GSTypography.headingSmall),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ExportFormatTile(
            format: ExportFormat.gpx,
            icon: Icons.navigation,
            description: 'Format GPS standard',
            onTap: () {
              Navigator.of(context).pop();
              onExport(ExportFormat.gpx);
            },
          ),
          const SizedBox(height: GSSpacing.m),
          _ExportFormatTile(
            format: ExportFormat.kml,
            icon: Icons.public,
            description: 'Google Earth / Maps',
            onTap: () {
              Navigator.of(context).pop();
              onExport(ExportFormat.kml);
            },
          ),
          const SizedBox(height: GSSpacing.m),
          _ExportFormatTile(
            format: ExportFormat.geoJSON,
            icon: Icons.code,
            description: 'Format JSON géographique',
            onTap: () {
              Navigator.of(context).pop();
              onExport(ExportFormat.geoJSON);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
      ],
    );
  }
}

class _ExportFormatTile extends StatelessWidget {
  const _ExportFormatTile({
    required this.format,
    required this.icon,
    required this.description,
    required this.onTap,
    this.enabled = true,
  });

  final ExportFormat format;
  final IconData icon;
  final String description;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GSCard(
      onTap: enabled ? onTap : null,
      padding: const EdgeInsets.all(GSSpacing.l),
      border: Border.all(
        color: enabled ? GSColors.primary600 : GSColors.neutral300,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(GSSpacing.m),
            decoration: BoxDecoration(
              color: enabled
                  ? GSColors.primary600.withValues(alpha: 0.1)
                  : GSColors.neutral200,
              borderRadius: BorderRadius.circular(GSRadius.s),
            ),
            child: Icon(
              icon,
              color: enabled ? GSColors.primary600 : GSColors.neutral400,
            ),
          ),
          const SizedBox(width: GSSpacing.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  format.extension.toUpperCase(),
                  style: GSTypography.bodyAccentMedium.copyWith(
                    color: enabled ? GSColors.neutral1000 : GSColors.neutral400,
                  ),
                ),
                const SizedBox(height: GSSpacing.xs),
                Text(
                  description,
                  style: GSTypography.bodyDefaultSmall.copyWith(
                    color: GSColors.neutral600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
