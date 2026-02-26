import 'package:flutter/material.dart';

import '../../../../../shared/design_system/design_system.dart';
import 'map_category_chip.dart';

class MapTopPanel extends StatelessWidget {
  const MapTopPanel({
    super.key,
    required this.isAuthenticated,
    required this.isShareInfoVisible,
    required this.isSearchMode,
    required this.searchQuery,
    required this.selectedCategory,
    required this.categories,
    required this.onSearchTap,
    required this.onDismissShareInfo,
    required this.onClearSearch,
    required this.onCategorySelected,
  });

  final bool isAuthenticated;
  final bool isShareInfoVisible;
  final bool isSearchMode;
  final String searchQuery;
  final String selectedCategory;
  final List<(String, IconData)> categories;
  final Future<void> Function() onSearchTap;
  final VoidCallback onDismissShareInfo;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GSCard(
          padding: const EdgeInsets.all(GSSpacing.l),
          borderRadius: BorderRadius.circular(GSRadius.l),
          color: GSColors.neutral000.withValues(alpha: 0.82),
          border: Border.all(color: GSColors.neutral300),
          shadows: const [],
          onTap: onSearchTap,
          child: Row(
            children: [
              const Icon(Icons.search, color: GSColors.slate400),
              const SizedBox(width: GSSpacing.m),
              Expanded(
                child: Text(
                  searchQuery.isEmpty ? 'Rechercher un lieu...' : searchQuery,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GSTypography.bodyDefaultMedium.copyWith(
                    color: searchQuery.isEmpty
                        ? GSColors.slate400
                        : GSColors.neutral800,
                  ),
                ),
              ),
              if (searchQuery.isNotEmpty)
                GSIconButton(
                  icon: Icons.close,
                  tooltip: 'Effacer',
                  onPressed: onClearSearch,
                ),
            ],
          ),
        ),
        if (!isSearchMode) ...[
          const SizedBox(height: GSSpacing.l),
          if (isAuthenticated)
            GSCard(
              padding: const EdgeInsets.all(GSSpacing.l),
              borderRadius: BorderRadius.circular(GSRadius.l),
              color: GSColors.neutral000.withValues(alpha: 0.82),
              border: Border.all(color: GSColors.neutral300),
              shadows: const [],
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final category in categories)
                      Padding(
                        padding: const EdgeInsets.only(right: GSSpacing.s),
                        child: MapCategoryChip(
                          label: category.$1,
                          icon: category.$2,
                          isSelected: selectedCategory == category.$1,
                          onTap: () => onCategorySelected(category.$1),
                        ),
                      ),
                  ],
                ),
              ),
            )
          else if (isShareInfoVisible)
            GSCard(
              padding: const EdgeInsets.all(GSSpacing.l),
              borderRadius: BorderRadius.circular(GSRadius.l),
              color: GSColors.neutral000.withValues(alpha: 0.82),
              border: Border.all(color: GSColors.neutral300),
              shadows: const [],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.group_outlined,
                    color: GSColors.primary600,
                    size: 18,
                  ),
                  const SizedBox(width: GSSpacing.s),
                  Expanded(
                    child: Text(
                      'Mode partage: vous voyez les lieux partagés avec vous.',
                      style: GSTypography.bodyDefaultSmall.copyWith(
                        color: GSColors.neutral700,
                      ),
                    ),
                  ),
                  GSIconButton(
                    icon: Icons.close,
                    tooltip: 'Masquer ce message',
                    onPressed: onDismissShareInfo,
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
