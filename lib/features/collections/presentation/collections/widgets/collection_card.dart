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
                width: 60,
                height: 60,
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
                      label: isAllCollection
                          ? 'Collection système'
                          : 'Collection',
                      icon: isAllCollection
                          ? Icons.auto_awesome
                          : Icons.label_outline,
                      backgroundColor: GSColors.neutral100,
                      borderColor: GSColors.neutral150,
                      foregroundColor: GSColors.neutral700,
                    ),
                    const SizedBox(height: GSSpacing.m),
                    Text(
                      isAllCollection ? 'Tous les lieux' : collection.tag,
                      style: GSTypography.bodyAccentLarge.copyWith(
                        color: GSColors.neutral1000,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.xs),
                    Text(
                      isAllCollection
                          ? 'Votre répertoire complet pour explorer l\'ensemble des lieux.'
                          : 'Une collection claire pour regrouper vos lieux les plus utiles.',
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral650,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.xl),
          Wrap(
            spacing: GSSpacing.s,
            runSpacing: GSSpacing.s,
            children: [
              GSInfoChip(
                icon: Icons.place_outlined,
                label: placesLabel,
                backgroundColor: GSColors.primary50,
                borderColor: GSColors.primary100,
                foregroundColor: GSColors.primary700,
              ),
              GSInfoChip(
                icon: Icons.visibility_outlined,
                label: isAllCollection ? 'Vue globale' : 'Accès rapide',
                backgroundColor: GSColors.neutral100,
                borderColor: GSColors.neutral150,
              ),
            ],
          ),
          const SizedBox(height: GSSpacing.xl),
          Row(
            children: [
              Text(
                'Ouvrir la collection',
                style: GSTypography.labelAccent.copyWith(
                  color: GSColors.primary700,
                ),
              ),
              const SizedBox(width: GSSpacing.s),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: GSColors.primary700,
              ),
              const Spacer(),
              if (!isAllCollection) ...[
                _ActionIconButton(
                  icon: Icons.download_outlined,
                  tooltip: 'Exporter',
                  onPressed: () => _showExportDialog(context, ref),
                ),
                const SizedBox(width: GSSpacing.s),
                _ActionIconButton(
                  icon: Icons.share_outlined,
                  tooltip: 'Partager',
                  onPressed: () => _showShareDialog(context, ref),
                ),
              ] else if (onTap != null)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: GSColors.neutral400,
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

class _ActionIconButton extends StatelessWidget {
  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GSColors.neutral050,
        borderRadius: BorderRadius.circular(GSRadius.full),
        border: Border.all(color: GSColors.neutral150),
      ),
      child: GSIconButton(
        icon: icon,
        onPressed: onPressed,
        size: 20,
        color: GSColors.neutral700,
        tooltip: tooltip,
      ),
    );
  }
}
