import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/add_shared_access_dialog.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/collections_tabs.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/tabs/owned_collections_tab_view.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/tabs/shared_by_me_collections_tab_view.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/tabs/shared_with_me_collections_tab_view.dart';
import 'package:geo_spots/features/collections/presentation/route/route_data.dart'
    show CollectionDetailsRouteData;
import 'package:geo_spots/features/collections/presentation/collections/widgets/collections_header.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/collections_state.dart';
import '../../view_model/collections_view_model.dart';

class CollectionsView extends ConsumerWidget {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticationStatus = ref.watch(authenticationNotifierProvider);
    final isAuthenticated =
        authenticationStatus is AuthenticationStatusAuthenticated;
    final state = ref.watch(collectionsViewModelProvider);
    final notifier = ref.read(collectionsViewModelProvider.notifier);

    if (state.isLoading) {
      return const Center(child: GSCircularLoader());
    }

    final ownedSharesByCollection = <String, List<SharedAccessTokenEntity>>{};
    for (final token in state.ownedShareTokens) {
      if (token.resourceType != 'collection' || token.resourceId.isEmpty) {
        continue;
      }
      ownedSharesByCollection.putIfAbsent(token.resourceId, () => []).add(token);
    }
    final sharedByMeCollections = state.ownedCollections
        .where(
          (collection) =>
              collection.tag != 'all' &&
              ownedSharesByCollection.containsKey(collection.tag),
        )
        .toList();
    final effectiveTab = isAuthenticated
        ? state.selectedTab
        : CollectionsTab.sharedWithMe;

    final collections = switch (effectiveTab) {
      CollectionsTab.owned => state.ownedCollections,
      CollectionsTab.sharedWithMe => state.sharedCollections,
      CollectionsTab.sharedByMe => sharedByMeCollections,
    };
    final title = switch (effectiveTab) {
      CollectionsTab.owned => 'Mes Collections',
      CollectionsTab.sharedWithMe => 'Partagées avec moi',
      CollectionsTab.sharedByMe => 'Partagées par moi',
    };
    final placesCount = switch (effectiveTab) {
      CollectionsTab.owned => state.totalPlaces,
      CollectionsTab.sharedWithMe => collections.fold<int>(
          0,
          (sum, c) => sum + c.placesCount,
        ),
      CollectionsTab.sharedByMe => sharedByMeCollections.fold<int>(
          0,
          (sum, c) => sum + c.placesCount,
        ),
    };
    final totalCollections = collections.length;
    Future<void> openCollectionDetails(CollectionEntity collection) async {
      await notifier.activateSharedCollection(collection);
      if (!context.mounted) {
        return;
      }
      CollectionDetailsRouteData(collectionTag: collection.tag).push(context);
    }

    final tabView = switch (effectiveTab) {
      CollectionsTab.owned => OwnedCollectionsTabView(
          collections: state.ownedCollections,
          onCollectionTap: openCollectionDetails,
        ),
      CollectionsTab.sharedWithMe => SharedWithMeCollectionsTabView(
          collections: state.sharedCollections,
          onCollectionTap: openCollectionDetails,
          onRemoveAccess: notifier.revokeSharedAccess,
        ),
      CollectionsTab.sharedByMe => SharedByMeCollectionsTabView(
          collections: sharedByMeCollections,
          tokensByCollection: ownedSharesByCollection,
          onCollectionTap: openCollectionDetails,
          onRevokeToken: notifier.revokeOwnedShare,
        ),
    };

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: CollectionsHeader(
            title: title,
            totalCollections: totalCollections,
            totalPlaces: placesCount,
            onImportPressed: isAuthenticated
                ? notifier.importCollection
                : null,
            onAddSharedAccessPressed: () => _showAddSharedAccessDialog(context),
          ),
        ),
        if (isAuthenticated)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                GSSpacing.xl,
                GSSpacing.m,
                GSSpacing.xl,
                0,
              ),
              child: CollectionsTabs(
                selectedTab: state.selectedTab,
                onTabChanged: notifier.selectTab,
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.all(GSSpacing.xl),
          sliver: SliverToBoxAdapter(child: tabView),
        ),
      ],
    );
  }
}

void _showAddSharedAccessDialog(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (_) => const AddSharedAccessDialog(),
  );
}
