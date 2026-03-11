import 'package:flutter/material.dart';
import 'package:geo_spots/features/authentication/domain/entity/authentication_status/authentication_status.dart';
import 'package:geo_spots/features/authentication/domain/navigator/authentication_notifier.dart';
import 'package:geo_spots/features/collections/domain/entity/collection_entity.dart';
import 'package:geo_spots/features/collections/domain/entity/shared_access_token_entity.dart';
import 'package:geo_spots/features/collections/domain/enums/share_resource_type.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/add_shared_access_dialog.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/collections_header.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/collections_tabs.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/tabs/owned_collections_tab_view.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/tabs/shared_by_me_collections_tab_view.dart';
import 'package:geo_spots/features/collections/presentation/collections/widgets/tabs/shared_with_me_collections_tab_view.dart';
import 'package:geo_spots/features/collections/presentation/route/route_data.dart'
    show CollectionDetailsRouteData;
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/design_system/design_system.dart';
import '../../view_model/collections_state.dart';
import '../../view_model/collections_view_model.dart';

class CollectionsView extends ConsumerWidget {
  const CollectionsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      collectionsViewModelProvider.select((state) => state.snackbarMessage),
      (previous, next) {
        if (next == null || previous == next) {
          return;
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) {
            return;
          }
          next.show(context);
          ref.read(collectionsViewModelProvider.notifier).consumeSnackbar();
        });
      },
    );

    final authenticationStatus = ref.watch(authGuardProvider);
    final isAuthenticated =
        authenticationStatus is AuthenticationStatusAuthenticated;
    final state = ref.watch(collectionsViewModelProvider);
    final notifier = ref.read(collectionsViewModelProvider.notifier);

    if (state.isLoading) {
      return const Center(child: GSCircularLoader());
    }

    final ownedSharesByCollection = <String, List<SharedAccessTokenEntity>>{};
    for (final token in state.ownedShareTokens) {
      if (ShareResourceType.fromRaw(token.resourceType) !=
              ShareResourceType.collection ||
          token.resourceId.isEmpty) {
        continue;
      }
      ownedSharesByCollection
          .putIfAbsent(token.resourceId, () => [])
          .add(token);
    }
    final sharedTokensByCollection = <String, SharedAccessTokenEntity>{};
    for (final token in state.sharedTokens) {
      if (ShareResourceType.fromRaw(token.resourceType) !=
              ShareResourceType.collection ||
          token.resourceId.isEmpty) {
        continue;
      }
      sharedTokensByCollection[token.resourceId] = token;
    }
    final sharedByMeCollections = state.ownedCollections
        .where(
          (collection) => ownedSharesByCollection.containsKey(collection.id),
        )
        .toList();
    final effectiveTab = isAuthenticated
        ? state.selectedTab
        : CollectionsTab.sharedWithMe;

    final title = switch (effectiveTab) {
      CollectionsTab.owned => 'Mes Collections',
      CollectionsTab.sharedWithMe => 'Partagées avec moi',
      CollectionsTab.sharedByMe => 'Partagées par moi',
    };
    Future<void> openCollectionDetails(CollectionEntity collection) async {
      await notifier.activateSharedCollection(collection);
      if (!context.mounted) {
        return;
      }
      await CollectionDetailsRouteData(
        collectionTag: collection.tag,
      ).push<void>(context);
    }

    final tabView = switch (effectiveTab) {
      CollectionsTab.owned => OwnedCollectionsTabView(
        collections: state.ownedCollections,
        onCollectionTap: openCollectionDetails,
      ),
      CollectionsTab.sharedWithMe => SharedWithMeCollectionsTabView(
        collections: state.sharedCollections,
        sharedTokensByCollectionId: sharedTokensByCollection,
        onCollectionTap: openCollectionDetails,
        onRemoveAccess: notifier.revokeSharedAccess,
      ),
      CollectionsTab.sharedByMe => SharedByMeCollectionsTabView(
        collections: sharedByMeCollections,
        tokensByCollection: ownedSharesByCollection,
        onCollectionTap: openCollectionDetails,
        onRevokeTokenById: notifier.revokeOwnedShare,
      ),
    };

    return Column(
      children: [
        CollectionsHeader(
          title: title,
          onImportPressed: isAuthenticated ? notifier.importCollection : null,
          onAddSharedAccessPressed: () => _showAddSharedAccessDialog(context),
        ),
        if (isAuthenticated)
          Padding(
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
        Expanded(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(GSSpacing.xl),
              child: tabView,
            ),
          ),
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
