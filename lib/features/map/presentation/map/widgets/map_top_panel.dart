import 'dart:ui';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(GSRadius.l),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Material(
              color: GSColors.neutral000.withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(GSRadius.l),
              child: InkWell(
                onTap: onSearchTap,
                borderRadius: BorderRadius.circular(GSRadius.l),
                child: Ink(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GSSpacing.l,
                    vertical: GSSpacing.l,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(GSRadius.l),
                    border: Border.all(
                      color: GSColors.neutral000.withValues(alpha: 0.72),
                    ),
                    boxShadow: [
                      GSShadows.m(
                        color: GSColors.neutral1000.withValues(alpha: 0.10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: GSColors.slate400),
                      const SizedBox(width: GSSpacing.m),
                      Expanded(
                        child: Text(
                          searchQuery.isEmpty
                              ? 'Rechercher un lieu, une ville, un tag...'
                              : searchQuery,
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
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: GSColors.neutral100,
                            borderRadius: BorderRadius.circular(GSRadius.full),
                          ),
                          child: GSIconButton(
                            icon: Icons.close,
                            tooltip: 'Effacer',
                            onPressed: onClearSearch,
                            size: 18,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (!isSearchMode) ...[
          const SizedBox(height: GSSpacing.l),
          if (isAuthenticated)
            SizedBox(
              height: 44,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(right: 84),
                itemCount: categories.length,
                separatorBuilder: (_, _) => const SizedBox(width: GSSpacing.s),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return MapCategoryChip(
                    label: category.$1,
                    icon: category.$2,
                    isSelected: selectedCategory == category.$1,
                    onTap: () => onCategorySelected(category.$1),
                  );
                },
              ),
            )
          else if (isShareInfoVisible)
            _GlassPanel(
              padding: const EdgeInsets.all(GSSpacing.l),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: GSColors.primary50,
                      borderRadius: BorderRadius.circular(GSRadius.m),
                    ),
                    child: const Icon(
                      Icons.group_outlined,
                      color: GSColors.primary700,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: GSSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mode partage',
                          style: GSTypography.bodyAccentMedium.copyWith(
                            color: GSColors.neutral900,
                          ),
                        ),
                        const SizedBox(height: GSSpacing.xs),
                        Text(
                          'Vous voyez les lieux partagés avec vous dans une expérience de lecture simplifiée.',
                          style: GSTypography.bodyDefaultSmall.copyWith(
                            color: GSColors.neutral700,
                          ),
                        ),
                      ],
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

class _GlassPanel extends StatelessWidget {
  const _GlassPanel({
    required this.child,
    this.padding = const EdgeInsets.all(GSSpacing.l),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(GSRadius.l),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: GSColors.neutral000.withValues(alpha: 0.74),
            borderRadius: BorderRadius.circular(GSRadius.l),
            border: Border.all(
              color: GSColors.neutral000.withValues(alpha: 0.72),
            ),
            boxShadow: [
              GSShadows.m(color: GSColors.neutral1000.withValues(alpha: 0.10)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
