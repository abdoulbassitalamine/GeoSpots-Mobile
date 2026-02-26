import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/presentation/view_model/collections_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../../shared/design_system/design_system.dart';
import 'export_dialog.dart';
import 'share_collection_dialog.dart';

class CollectionCard extends ConsumerWidget {
  const CollectionCard({
    super.key,
    required this.collection,
    required this.onTap,
  });
  final CollectionEntity collection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isAllCollection = collection.tag == 'all';

    return GSCard(
      onTap: onTap,
      padding: const EdgeInsets.all(GSSpacing.xl),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: GSColors.primary600.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(GSRadius.m),
            ),
            child: Icon(
              isAllCollection ? Icons.public : Icons.label,
              color: GSColors.primary600,
              size: 28,
            ),
          ),
          const SizedBox(width: GSSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAllCollection ? 'Tous les lieux' : collection.tag,
                  style: GSTypography.bodyAccentMedium.copyWith(
                    color: GSColors.neutral1000,
                    fontSize: GSFontScale.sf05,
                  ),
                ),
                const SizedBox(height: GSSpacing.xs),
                Text(
                  isAllCollection
                      ? '${collection.placesCount} lieux enregistrés'
                      : '${collection.placesCount} ${collection.placesCount > 1 ? 'lieux' : 'lieu'}',
                  style: GSTypography.bodyDefaultSmall.copyWith(
                    color: GSColors.neutral600,
                  ),
                ),
              ],
            ),
          ),
          if (!isAllCollection)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GSIconButton(
                  icon: Icons.download,
                  onPressed: () => _showExportDialog(context, ref),
                  size: 24,
                  tooltip: 'Exporter',
                ),
                const SizedBox(width: GSSpacing.s),
                GSIconButton(
                  icon: Icons.share,
                  onPressed: () => _showShareDialog(context, ref),
                  size: 24,
                  tooltip: 'Partager',
                ),
              ],
            )
          else if (onTap != null)
            const Icon(Icons.chevron_right, color: GSColors.neutral400),
        ],
      ),
    );
  }

  void _showExportDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => ExportDialog(
        collection: collection,
        onExport: (format) {
          ref
              .read(collectionsViewModelProvider.notifier)
              .exportCollection(collection, format);
        },
      ),
    );
  }

  void _showShareDialog(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (context) => ShareCollectionDialog(
        onShare: (accessRight) {
          ref
              .read(collectionsViewModelProvider.notifier)
              .shareCollection(collection, accessRight);
        },
      ),
    );
  }
}
