import 'package:flutter/material.dart';
import 'package:geo_spots/features/collections/presentation/view_model/collections_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../../shared/design_system/design_system.dart';

class CollectionsHeader extends ConsumerWidget {
  final int totalCollections;
  final int totalPlaces;

  const CollectionsHeader({
    super.key,
    required this.totalCollections,
    required this.totalPlaces,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mes Collections',
                      style: GSTypography.headingMedium.copyWith(
                        color: GSColors.neutral000,
                        fontSize: GSFontScale.sf07,
                      ),
                    ),
                    const SizedBox(height: GSSpacing.s),
                    Text(
                      '$totalCollections ${totalCollections > 1 ? 'collections' : 'collection'} • $totalPlaces ${totalPlaces > 1 ? 'lieux' : 'lieu'}',
                      style: GSTypography.bodyDefaultMedium.copyWith(
                        color: GSColors.neutral000.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: GSColors.neutral000.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(GSRadius.m),
                ),
                child: IconButton(
                  onPressed: () => ref
                      .read(collectionsViewModelProvider.notifier)
                      .importCollection(),
                  icon: const Icon(
                    Icons.upload_file,
                    color: GSColors.neutral000,
                  ),
                  iconSize: 28,
                  tooltip: 'Importer une collection',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
