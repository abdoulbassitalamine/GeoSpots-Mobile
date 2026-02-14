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
    return DefaultTabController(
      key: ValueKey(selectedTab),
      length: 3,
      initialIndex: _indexFromTab(selectedTab),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          labelColor: GSColors.primary600,
          unselectedLabelColor: GSColors.neutral600,
          indicatorColor: GSColors.primary600,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: GSTypography.bodyAccentMedium,
          unselectedLabelStyle: GSTypography.bodyDefaultMedium,
          onTap: (index) => onTabChanged(_tabFromIndex(index)),
          tabs: const [
            Tab(text: 'Mes collections'),
            Tab(text: 'Partagées avec moi'),
            Tab(text: 'Partagées par moi'),
          ],
        ),
      ),
    );
  }
}

CollectionsTab _tabFromIndex(int index) {
  switch (index) {
    case 0:
      return CollectionsTab.owned;
    case 1:
      return CollectionsTab.sharedWithMe;
    case 2:
      return CollectionsTab.sharedByMe;
    default:
      return CollectionsTab.owned;
  }
}

int _indexFromTab(CollectionsTab tab) {
  switch (tab) {
    case CollectionsTab.owned:
      return 0;
    case CollectionsTab.sharedWithMe:
      return 1;
    case CollectionsTab.sharedByMe:
      return 2;
  }
}
