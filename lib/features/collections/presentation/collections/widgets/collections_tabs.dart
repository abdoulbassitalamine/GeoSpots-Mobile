import 'package:flutter/material.dart';

import '../../../../../../shared/design_system/design_system.dart';
import '../../view_model/collections_state.dart';

class CollectionsTabs extends StatefulWidget {
  const CollectionsTabs({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final CollectionsTab selectedTab;
  final ValueChanged<CollectionsTab> onTabChanged;

  @override
  State<CollectionsTabs> createState() => _CollectionsTabsState();
}

class _CollectionsTabsState extends State<CollectionsTabs> {
  final ScrollController _scrollController = ScrollController();
  final Map<CollectionsTab, GlobalKey> _pillKeys = {
    CollectionsTab.owned: GlobalKey(),
    CollectionsTab.sharedWithMe: GlobalKey(),
    CollectionsTab.sharedByMe: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();
    _ensureSelectedTabVisible();
  }

  @override
  void didUpdateWidget(covariant CollectionsTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedTab != widget.selectedTab) {
      _ensureSelectedTabVisible();
    }
  }

  void _ensureSelectedTabVisible() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final context = _pillKeys[widget.selectedTab]?.currentContext;
      if (context == null) {
        return;
      }
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        alignment: 0.5,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: GSColors.neutral100,
        borderRadius: BorderRadius.circular(GSRadius.l),
        border: Border.all(color: GSColors.neutral150),
      ),
      child: Padding(
        padding: const EdgeInsets.all(GSSpacing.xs),
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _CollectionsTabPill(
                key: _pillKeys[CollectionsTab.owned],
                label: 'À moi',
                icon: Icons.folder_copy_outlined,
                selected: widget.selectedTab == CollectionsTab.owned,
                onTap: () => widget.onTabChanged(CollectionsTab.owned),
              ),
              const SizedBox(width: GSSpacing.xs),
              _CollectionsTabPill(
                key: _pillKeys[CollectionsTab.sharedWithMe],
                label: 'Reçues',
                icon: Icons.folder_shared_outlined,
                selected: widget.selectedTab == CollectionsTab.sharedWithMe,
                onTap: () => widget.onTabChanged(CollectionsTab.sharedWithMe),
              ),
              const SizedBox(width: GSSpacing.xs),
              _CollectionsTabPill(
                key: _pillKeys[CollectionsTab.sharedByMe],
                label: 'Partagées',
                icon: Icons.key_outlined,
                selected: widget.selectedTab == CollectionsTab.sharedByMe,
                onTap: () => widget.onTabChanged(CollectionsTab.sharedByMe),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionsTabPill extends StatelessWidget {
  const _CollectionsTabPill({
    super.key,
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
    final backgroundColor = selected ? GSColors.neutral000 : Colors.transparent;
    final foregroundColor = selected
        ? GSColors.primary700
        : GSColors.neutral700;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(GSRadius.l),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
            horizontal: GSSpacing.m,
            vertical: GSSpacing.m,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(GSRadius.l),
            border: Border.all(
              color: selected ? GSColors.primary100 : Colors.transparent,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: GSColors.neutral1000.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
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
