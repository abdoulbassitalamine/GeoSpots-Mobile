import 'package:flutter/material.dart';

import '../../../../../../shared/design_system/design_system.dart';
import '../../view_model/collections_state.dart';

class CollectionsTabs extends StatelessWidget {
  const CollectionsTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final CollectionsTab selectedTab;
  final ValueChanged<CollectionsTab> onTabChanged;

  @override
  Widget build(BuildContext context) {
    return GSPremiumPanel(
      padding: const EdgeInsets.all(GSSpacing.s),
      backgroundColor: GSColors.neutral000,
      borderColor: GSColors.neutral150,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _CollectionsTabPill(
              label: 'Mes collections',
              icon: Icons.folder_copy_outlined,
              selected: selectedTab == CollectionsTab.owned,
              onTap: () => onTabChanged(CollectionsTab.owned),
            ),
            const SizedBox(width: GSSpacing.s),
            _CollectionsTabPill(
              label: 'Partagées avec moi',
              icon: Icons.folder_shared_outlined,
              selected: selectedTab == CollectionsTab.sharedWithMe,
              onTap: () => onTabChanged(CollectionsTab.sharedWithMe),
            ),
            const SizedBox(width: GSSpacing.s),
            _CollectionsTabPill(
              label: 'Partagées par moi',
              icon: Icons.key_outlined,
              selected: selectedTab == CollectionsTab.sharedByMe,
              onTap: () => onTabChanged(CollectionsTab.sharedByMe),
            ),
          ],
        ),
      ),
    );
  }
}

class _CollectionsTabPill extends StatelessWidget {
  const _CollectionsTabPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = selected
        ? GSColors.primary600
        : GSColors.neutral050;
    final foregroundColor = selected
        ? GSColors.neutral000
        : GSColors.neutral700;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GSRadius.full),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: GSSpacing.xl,
            vertical: GSSpacing.l,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(GSRadius.full),
            border: Border.all(
              color: selected ? GSColors.primary600 : GSColors.neutral150,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: foregroundColor),
              const SizedBox(width: GSSpacing.s),
              Text(
                label,
                style: GSTypography.bodyAccentMedium.copyWith(
                  color: foregroundColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
