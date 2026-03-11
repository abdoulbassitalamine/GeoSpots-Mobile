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
    final title = isAllCollection ? 'Tous les lieux' : collection.tag;
    final placesLabel =
        '${collection.placesCount} ${collection.placesCount > 1 ? 'lieux' : 'lieu'}';

    return GSPremiumPanel(
      onTap: onTap,
      padding: const EdgeInsets.all(GSSpacing.xl),
      borderColor: GSColors.neutral150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      GSColors.primary100,
                      GSColors.primary600.withValues(alpha: 0.18),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(GSRadius.l),
                ),
                child: Icon(
                  isAllCollection
                      ? Icons.public_rounded
                      : Icons.folder_open_rounded,
                  color: GSColors.primary700,
                  size: 28,
                ),
              ),
              const SizedBox(width: GSSpacing.l),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GSInfoChip(
                      label: isAllCollection ? 'Système' : 'Personnelle',
                      icon: isAllCollection
                          ? Icons.auto_awesome
                          : Icons.label_outline,
                      backgroundColor: GSColors.neutral100,
                      borderColor: GSColors.neutral150,
                      foregroundColor: GSColors.neutral700,
                    ),
                    const SizedBox(height: GSSpacing.m),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GSTypography.bodyAccentLarge.copyWith(
                              color: GSColors.neutral1000,
                              fontSize: GSFontScale.sf03,
                            ),
                          ),
                        ),
                        if (onTap != null)
                          const Padding(
                            padding: EdgeInsets.only(left: GSSpacing.s),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              color: GSColors.neutral400,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.l),
          Wrap(
            spacing: GSSpacing.s,
            children: [
              GSInfoChip(
                icon: Icons.place_outlined,
                label: placesLabel,
                backgroundColor: GSColors.primary50,
                borderColor: GSColors.primary100,
                foregroundColor: GSColors.primary700,
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.l),
          if (!isAllCollection)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _ActionButton(
                  icon: Icons.download_outlined,
                  label: 'Exporter',
                  onPressed: () => _showExportDialog(context, ref),
                ),
                const SizedBox(width: GSSpacing.s),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Partager',
                  onPressed: () => _showShareDialog(context, ref),
                ),
              ],
            ),
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(GSRadius.full),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: GSSpacing.m,
            vertical: GSSpacing.s,
          ),
          decoration: BoxDecoration(
            color: GSColors.neutral050,
            borderRadius: BorderRadius.circular(GSRadius.full),
            border: Border.all(color: GSColors.neutral150),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: GSColors.neutral700),
              const SizedBox(width: GSSpacing.xs),
              Text(
                label,
                style: GSTypography.captionDefault.copyWith(
                  color: GSColors.neutral700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
